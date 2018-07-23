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
    
    func saveVideoToLibrary() {
        if FileManager.default.fileExists(atPath: tempPath) {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.tempURL)
            }) { saved, error in
                if saved {
                    print("saved")
                }
            }
        }
    }
}
