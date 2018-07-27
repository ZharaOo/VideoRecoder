//
//  CameraData.swift
//  VideoRecoder
//
//  Created by Ivan Babkin on 23.07.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit
import Photos

class CameraData: NSObject {
    var tempPath: String
    var tempURL: URL {
        return URL(fileURLWithPath: tempPath)
    }
    
    override init() {
        tempPath = String(format: "%@/%@.mov", NSTemporaryDirectory(), UUID.init().uuidString)
    }
    
    func saveVideoLocaly() throws {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        var videosNames = try? FileManager.default.contentsOfDirectory(atPath: documentsPath)
        
        var videoName: String
        
        if videosNames != nil && videosNames!.count > 0 {
            videosNames = videosNames!.sorted(by: <)
            let lastName = videosNames!.last
            let ln = lastName!.split(separator: "_")
            let numberOfVideo = NumberFormatter().number(from: String(ln.last!))!.intValue
            
            videoName = "movie_\(numberOfVideo + 1)"
        }
        else {
            videoName = "movie_1"
        }
        
        do {
            try saveVideo(named: videoName, to: documentsPath)
        }
        catch {
            try? FileManager.default.removeItem(at: tempURL)
            throw error
        }
    }
    
    func saveVideo(named name:String, to directory: String) throws {
        let dUrl = URL(fileURLWithPath: directory).appendingPathComponent(name)
        let vUrl = dUrl.appendingPathComponent("\(name).mov")
        
        do {
            try FileManager.default.createDirectory(at: dUrl, withIntermediateDirectories: false, attributes: nil)
            try FileManager.default.copyItem(at: tempURL, to: vUrl)
        }
        catch {
            throw error
        }
        
        try? FileManager.default.removeItem(at: tempURL)
        
        if let preview = try fetchFirstFrameOf(videoURL: vUrl) {
            let data = UIImagePNGRepresentation(preview)
            try data?.write(to: URL(fileURLWithPath: directory).appendingPathComponent(name).appendingPathComponent("\(name).png"))
        }
    }
    
    func fetchFirstFrameOf(videoURL url: URL) throws -> UIImage? {
        let asset = AVURLAsset(url: url, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        
        do {
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            return thumbnail
            
        } catch let error {
            throw error
        }
    }
    
//    func saveVideoToLibrary() {
//        if FileManager.default.fileExists(atPath: tempPath) {
//            PHPhotoLibrary.shared().performChanges({
//                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.tempURL)
//            }) { saved, error in
//                if saved {
//                    print("saved")
//                }
//            }
//        }
//    }
}
