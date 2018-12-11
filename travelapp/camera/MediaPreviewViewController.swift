//
//  MediaPreviewViewController.swift
//  travelapp
//
//  Created by Mitchel Wassler on 12/1/18.
//  Copyright © 2018 Mitchel Wassler. All rights reserved.
//

import UIKit
import AVFoundation


class MediaPreviewViewController: UIViewController {
    
    var photo: UIImage?
    var video: AVAsset?
    var player: AVPlayer?
    
    var previewing = "photo"

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.previewing)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.contentSize = CGSize(width: 0, height: 1000)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch previewing {
        case "video":
            self.renderVideo()
        default:
            self.renderImage()
        }        
    }
    
    func renderVideo() {
        if let v = video {
            self.cropVideo(video: v)
        }
    }
    
    func offsetHeight(assetHeight: CGFloat ) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let centerView = previewView.bounds.height / 2
        let halfView = screenHeight / 2
        let offset = halfView - centerView
        let heightRation =  assetHeight / screenHeight
        return (offset * heightRation)
    }
    
    func renderImage() {
        if let p = photo {
            print("render image")
            let screenHeight = UIScreen.main.bounds.height
            let centerView = previewView.bounds.height / 2
            let halfView = screenHeight / 2
            let offset = halfView - centerView
            let heightRation =  p.size.height / screenHeight
            
            print("imgage height: \(p.size.height)")
            print("screen height: \(screenHeight)")
            print("offset: \(offset)")
            
            let croppedPhoto = self.cropImage( image: p, cropRect: CGRect(x: 0, y:  self.offsetHeight(assetHeight: p.size.height ) , width: p.size.width, height: p.size.width ) )
            let resizedPhoto = self.resizeImage(image: croppedPhoto, targetSize: CGSize(width: 375 * 2, height: 375 * 2))
            let imageView = UIImageView(image: resizedPhoto)
            imageView.frame = previewView.frame
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            previewView.addSubview(imageView)
        }
    }
    
    func setVideoPreview(video: AVAsset) {
        self.video = video
        self.previewing = "video"
    }
    
    func setPhotoPreview(photo: UIImage) {
        self.photo = photo
    }
    
//    private func cropVideo(asset: AVAsset) -> AVAsset {
//        var videoComposition: AVMutableVideoComposition = AVMutableVideoComposition()
//
//    }
    
    private func cropImage( image:UIImage , cropRect:CGRect) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(cropRect.size, false, image.scale)
        let origin = CGPoint(x: cropRect.origin.x * CGFloat(-1), y: cropRect.origin.y * CGFloat(-1))
        image.draw(at: origin)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return result!
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage
    {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
  
    
    func cropVideo(video: AVAsset) {
    
        
        var exporter = AVAssetExportSession(asset: video, presetName: AVAssetExportPresetHighestQuality)
        exporter!.videoComposition = self.squareVideoCompositionForAsset(asset: video)
        exporter!.outputURL = URL(fileURLWithPath: "\(NSTemporaryDirectory())\(NSUUID().uuidString).mov")
        exporter!.outputFileType = AVFileType.mov
        exporter!.exportAsynchronously(completionHandler: { () -> Void in
            self.video = AVAsset(url: exporter!.outputURL!)
            print(exporter!.outputURL!)
            let playerItem = AVPlayerItem(asset: self.video!)
            let player = AVPlayer(playerItem: playerItem)
            let playerLayerAV = AVPlayerLayer(player: player)
            playerLayerAV.frame = self.previewView.bounds
            self.view.layer.addSublayer(playerLayerAV)
            self.player = player
            player.play()
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
                player.seek(to: CMTime.zero)
                player.play()
            }
        })
        
    }
    
    func squareVideoCompositionForAsset(asset: AVAsset) -> AVVideoComposition {
        let track = asset.tracks(withMediaType: AVMediaType.video)[0]
        let length = max(track.naturalSize.width, track.naturalSize.height)
        let centerX = track.naturalSize.width / 2
        let centerY = track.naturalSize.height / 2
        let viewPortSize = self.previewView.frame.size.width
        let size = track.naturalSize
        let verticalWidthRation = viewPortSize / size.width
        let horizontalWidthRation = viewPortSize / size.height
        let sizeRatio = size.width / size.height
        let previewCenter =  viewPortSize / 2
        print(track.preferredTransform)
        print(centerY * verticalWidthRation)
        var transform = track.preferredTransform
            .translatedBy(x: -(track.naturalSize.width / 4), y:0)
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        transformer.setTransform(transform, at: CMTime.zero)
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: CMTime.zero, duration: CMTime.positiveInfinity)
        instruction.layerInstructions = [transformer]
        let composition = AVMutableVideoComposition()
        composition.frameDuration = CMTime(value: 1, timescale: 30)
        composition.renderSize = CGSize(width: track.naturalSize.height, height: track.naturalSize.height)
        composition.instructions = [instruction]
        return composition
    }
    
    func handleExportCompletion(session: AVAssetExportSession) {
        
        
//        var library = ALAssetsLibrary()
//
//        if library.videoAtPathIsCompatibleWithSavedPhotosAlbum(session.outputURL) {
//            var completionBlock: ALAssetsLibraryWriteVideoCompletionBlock
//
//            completionBlock = { assetUrl, error in
//                if error != nil {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            print("disappeared")
            NotificationCenter.default.removeObserver(self)
            self.player?.pause()
            self.player?.replaceCurrentItem(with: nil)
            self.player = nil
        }
    }

    
    
    deinit {
        // perform the deinitialization
        NotificationCenter.default.removeObserver(self)

    }
    
    

}
