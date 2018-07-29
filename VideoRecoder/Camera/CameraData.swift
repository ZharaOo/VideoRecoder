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
    
    func saveVideoLocaly() throws -> URL {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        var videoName: String
        
        if let lastVideoNumber = CameraData.getLastVideoNumber(in: documentsPath) {
            videoName = "movie_\(lastVideoNumber + 1)"
        }
        else {
            videoName = "movie_1"
        }
        
        do {
            let dUrl = try saveVideo(named: videoName, to: documentsPath)
            return dUrl
        }
        catch {
            try? FileManager.default.removeItem(at: tempURL)
            throw error
        }
    }
    
    func saveVideo(named name:String, to directory: String) throws -> URL {
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
        
        if let preview = try CameraData.fetchFirstFrameOf(videoURL: vUrl) {
            let data = UIImagePNGRepresentation(preview)
            try data?.write(to: URL(fileURLWithPath: directory).appendingPathComponent(name).appendingPathComponent("preview.png"))
        }
        
        return dUrl
    }
    
    
    //MARK: - class methods
    
    
    class func fetchFirstFrameOf(videoURL url: URL) throws -> UIImage? {
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
    
    class func saveVideoToLibrary(videoPath: String, completion: @escaping (_ error: Error?) -> ()) {
        if FileManager.default.fileExists(atPath: videoPath) {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: videoPath))
            }) { saved, error in
                if saved {
                    completion(nil)
                }
                else {
                    completion(error)
                }
            }
        }
    }
    
    class func getAllVideosDerictories() -> [URL] {
        var urls = [URL]()
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let videosNames = try? FileManager.default.contentsOfDirectory(atPath: documentsPath)
        
        videosNames?.forEach() { urls.append(URL(fileURLWithPath: documentsPath).appendingPathComponent($0)) }
        
        return urls
    }
    
    class func getLastVideoNumber(in directory: String) -> Int? {
        
        let videosNames = try? FileManager.default.contentsOfDirectory(atPath: directory)
        
        if videosNames != nil && videosNames!.count > 0 {
            let lastName = videosNames!.last
            let ln = lastName!.split(separator: "_")
            return NumberFormatter().number(from: String(ln.last!))!.intValue
        }
        
        return nil
    }
    
    class func getLastVideoDirectory() -> URL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        if let lastVideoNumber = getLastVideoNumber(in: documentsPath) {
            return URL(fileURLWithPath: documentsPath).appendingPathComponent("movie_\(lastVideoNumber)")
        }
        
        return nil
    }
    
    class func removeVideo(at url: URL) throws {
        do {
            try FileManager.default.removeItem(at: url)
        }
        catch {
            throw error
        }
    }
    
    
}
