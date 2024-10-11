//
//  FileManagerHelper.swift
//  IOS_Test_Task
//
//  Created by Oleg Zakladnyi on 11.10.2024.
//

import AVFoundation
import Photos
import UIKit

class VideoHelper {
    
    static func generateUniqueFileName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let currentDateTimeString = dateFormatter.string(from: Date())
        return currentDateTimeString
    }
    
    static func getFilePath(fileName: String) -> URL? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let filePath = documentsDirectory?.appendingPathComponent("\(fileName).mp4")
        return filePath
    }
    
    static func convertVideoAndSaveTophotoLibrary(videoURL: URL, watermarkLayerContents: CGImage?, completion: @escaping (URL?) -> Void) {
        
        let uniqueFileName = generateUniqueFileName()
        
        guard let filePath = getFilePath(fileName: "\(uniqueFileName)_video") else {
            print("Failed to create file path.")
            completion(nil)
            return
        }
        
        if FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.removeItem(atPath: filePath.path)
            } catch let error {
                print("Error removing file: \(error)")
                completion(nil)
                return
            }
        }
        
        let asset = AVURLAsset(url: videoURL)
        let composition = AVMutableComposition.init()
        composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        guard let clipVideoTrack = asset.tracks(withMediaType: AVMediaType.video).first else {
            print("Failed to retrieve video track")
            completion(nil)
            return
        }
        
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: clipVideoTrack)
        transformer.setTransform(clipVideoTrack.preferredTransform, at: CMTime.zero)
        transformer.setOpacity(0.0, at: asset.duration)
        
        let isVideoAssetPortrait_ = true
        
        var naturalSize: CGSize
        if isVideoAssetPortrait_ {
            naturalSize = CGSize(width: clipVideoTrack.naturalSize.height, height: clipVideoTrack.naturalSize.width)
        } else {
            naturalSize = clipVideoTrack.naturalSize
        }
        
        let renderWidth = naturalSize.width
        let renderHeight = naturalSize.height
        
        let parentlayer = CALayer()
        let videoLayer = CALayer()
        let watermarkLayer = CALayer()
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: renderWidth, height: renderHeight)
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
   
        if let watermarkContents = watermarkLayerContents {
            watermarkLayer.contents = watermarkContents
        }
        
        parentlayer.frame = CGRect(origin: .zero, size: naturalSize)
        videoLayer.frame = CGRect(origin: .zero, size: naturalSize)
        watermarkLayer.frame = CGRect(origin: .zero, size: naturalSize)
        
        parentlayer.addSublayer(videoLayer)
        parentlayer.addSublayer(watermarkLayer)
        
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayers: [videoLayer], in: parentlayer)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: CMTimeMakeWithSeconds(60, preferredTimescale: 30))
        
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
        exporter?.outputFileType = .mov
        exporter?.outputURL = filePath
        exporter?.videoComposition = videoComposition
        
        exporter?.exportAsynchronously {
            if exporter?.status == .completed {
                let outputURL = exporter?.outputURL
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL!)
                }) { saved, error in
                    if saved {
                        completion(outputURL)
                    } else {
                        print("Error saving video to photo library: \(String(describing: error))")
                        completion(nil)
                    }
                }
            } else {
                print("Export failed with status: \(String(describing: exporter?.status))")
                completion(nil)
            }
        }
    }
}
