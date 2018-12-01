//
//  CameraViewController.swift
//  travelapp
//
//  Created by Mitchel Wassler on 11/29/18.
//  Copyright © 2018 Mitchel Wassler. All rights reserved.
//






import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        let asset = AVAsset(url: outputFileURL)
        print("Finished Recording to: \(outputFileURL)")
        print(asset)
    }
    
    
    var captureSession: AVCaptureSession?
    var camera: AVCaptureDevice?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var previewView : UIView?
    var movieFileOutput = AVCaptureMovieFileOutput()
    
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
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setVideoOrientation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        previewView = UIView()
        previewView?.translatesAutoresizingMaskIntoConstraints = false
        
        let screenSize: CGRect = UIScreen.main.bounds
        print(screenSize.width)
        let screenWidth = screenSize.width
        view.addSubview(previewView!)
        previewView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        previewView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        previewView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        previewView?.heightAnchor.constraint(equalToConstant: screenWidth).isActive = true
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        if captureSession != nil {
            setPreview()
            setOutput()
            captureSession!.startRunning()
        }
        
    }
    
    func getCamera() {
//        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
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
        print(self.previewView!.frame)
        print(view.layer.bounds)
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = previewView!.frame
        previewView?.layer.addSublayer(videoPreviewLayer!)
        self.setVideoOrientation()
    }
    
    func setOutput() {
        self.captureSession?.addOutput(movieFileOutput)
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
    }
    
    @objc func longTap(_ sender: UIGestureRecognizer){
        print("Long tap")
        if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
            if self.movieFileOutput.isRecording {
                self.movieFileOutput.stopRecording()
            }
            //Do Whatever You want on End of Gesture
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
            //Do Whatever You want on Began of Gesture
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
