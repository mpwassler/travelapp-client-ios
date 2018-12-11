//
//  CameraViewController.swift
//  travelapp
//
//  Created by Mitchel Wassler on 11/29/18.
//  Copyright © 2018 Mitchel Wassler. All rights reserved.
//






import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureFileOutputRecordingDelegate, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var previewView: UIView!
    var captureSession: AVCaptureSession?
    var camera: AVCaptureDevice?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var movieFileOutput = AVCaptureMovieFileOutput()
    var photoFileOutput = AVCapturePhotoOutput()
    var capturedPhoto: UIImage?
    
    @IBOutlet weak var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(normalTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        cameraButton.addGestureRecognizer(tapGesture)
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
        cameraButton.addGestureRecognizer(longGesture)
        captureSession = AVCaptureSession()
        self.initalizeCamera()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setVideoOrientation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        if captureSession != nil {
            if !captureSession!.isRunning {
                setPreview()
                setOutput()
                captureSession!.startRunning()
            }            
        }
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
        if let data = imageData, let img = UIImage(data: data) {
            print(img)
            let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "mediapreview") as! MediaPreviewViewController
            viewController.setPhotoPreview(photo: img)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        let asset = AVAsset(url: outputFileURL)
        print("Finished Recording to: \(outputFileURL)")
        print(asset)
        let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "mediapreview") as! MediaPreviewViewController
        viewController.setVideoPreview(video: asset)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func toggleCamera(_ sender: Any) {
        if let session = self.captureSession {
            session.beginConfiguration()
            var existingConnection: AVCaptureDeviceInput!
            for connection in session.inputs {
                let input = connection as! AVCaptureDeviceInput
                if input.device.hasMediaType(AVMediaType.video) {
                    existingConnection = input
                }
            }
            session.removeInput(existingConnection)
            var newCamera: AVCaptureDevice!
            if let oldCamera = existingConnection {
                if oldCamera.device.position == .back {
                    newCamera = self.cameraWithPosition(position: .front)
                } else {
                    newCamera = self.cameraWithPosition(position: .back)
                }
            }
            var newInput: AVCaptureDeviceInput!
            do {
                newInput = try AVCaptureDeviceInput(device: newCamera)
                session.addInput(newInput)
            } catch {
                print(error)
            }
            session.commitConfiguration()
        }
    }
    
    func getCamera() {
        if let captureDevice = self.camera {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession?.addInput(input)
            } catch {
                print(error)
            }
        }
    }
    
    func setPreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = previewView!.frame
        previewView?.layer.insertSublayer(videoPreviewLayer!, at: 0)
        self.setVideoOrientation()
    }
    
    func setOutput() {
        self.captureSession?.addOutput(movieFileOutput)
        self.captureSession?.addOutput(photoFileOutput)
    }
    
    func setVideoOrientation() {
        if let connection = self.videoPreviewLayer?.connection {
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = self.videoOrientation()
            }
        }
    }
    
    func initalizeCamera() {
        let discovery = AVCaptureDevice.DiscoverySession.init(
            deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
            mediaType: AVMediaType.video,
            position: .unspecified ) as AVCaptureDevice.DiscoverySession
        for device in discovery.devices as [AVCaptureDevice] {
            if device.hasMediaType(AVMediaType.video) {
                if device.position == AVCaptureDevice.Position.back {
                    self.camera = device
                }
            }
        }
        if camera != nil {
            do {
                try self.captureSession?.addInput(AVCaptureDeviceInput(device: self.camera!))
                if let audioInput = AVCaptureDevice.default(for: AVMediaType.audio) {
                    try self.captureSession?.addInput(AVCaptureDeviceInput(device: audioInput))
                }
            } catch {
                print(error)
            }
        }
    }
    
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice?
    {
        let discovery = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified) as AVCaptureDevice.DiscoverySession
        for device in discovery.devices as [AVCaptureDevice] {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
    func videoOrientation() -> AVCaptureVideoOrientation {
        var videoOrientation: AVCaptureVideoOrientation!
        let orentation: UIDeviceOrientation = UIDevice.current.orientation
        switch orentation {
            case .portrait:
                videoOrientation = .portrait
                break
            case .landscapeRight:
                videoOrientation = .landscapeLeft
                break
            case .landscapeLeft:
                videoOrientation = .landscapeRight
                break
            case .portraitUpsideDown:
                videoOrientation = .portrait
                break
            default:
                videoOrientation = .portrait
        }
        return videoOrientation
    }
    
    func videoFileLocation() -> String {
        return NSTemporaryDirectory().appending("videoFile.mov")
    }
    
    func maxDuration() -> CMTime {
        let seconds : Int64 = 10
        let preferredTimeScale: Int32 = 1
        return CMTimeMake(value: seconds, timescale: preferredTimeScale)
    }
    
    @objc func normalTap(_ sender: UIGestureRecognizer){
        print("Normal tap")
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        self.photoFileOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @objc func longTap(_ sender: UIGestureRecognizer){
        print("Long tap")
        if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
            if self.movieFileOutput.isRecording {
                self.movieFileOutput.stopRecording()
            }
        }
        else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
            if !self.movieFileOutput.isRecording {
                self.movieFileOutput.connection(with: AVMediaType.video)?.videoOrientation = self.videoOrientation()
                self.movieFileOutput.maxRecordedDuration = self.maxDuration()
                self.movieFileOutput.startRecording(
                    to: URL(fileURLWithPath: self.videoFileLocation()),
                    recordingDelegate: self
                )
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        NotificationCenter.default.removeObserver(someObserver)

    }
    */

}
