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
        
        if videosNames != nil && videosNames!.count > 0 {
            videosNames = videosNames!.sorted(by: >)
            let lastName = videosNames!.last
            let ln = lastName!.split(separator: "_")
            let numberOfVideo = NumberFormatter().number(from: String(ln.last!))!.intValue
            do {
                try FileManager.default.createDirectory(at: URL(fileURLWithPath: documentsPath).appendingPathComponent("movie_\(numberOfVideo + 1)"), withIntermediateDirectories: false, attributes: nil)
                try FileManager.default.copyItem(at: tempURL, to: URL(fileURLWithPath: documentsPath).appendingPathComponent("movie_\(numberOfVideo + 1)").appendingPathComponent("movie_\(numberOfVideo + 1).mov"))
            }
            catch {
                throw error
            }
            
            try? FileManager.default.removeItem(at: tempURL)
        }
        else {
            do {
                try FileManager.default.createDirectory(at: URL(fileURLWithPath: documentsPath).appendingPathComponent("movie_1"), withIntermediateDirectories: false, attributes: nil)
                try FileManager.default.copyItem(at: tempURL, to: URL(fileURLWithPath: documentsPath).appendingPathComponent("movie_1").appendingPathComponent("movie_1.mov"))
            }
            catch {
                throw error
            }
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
