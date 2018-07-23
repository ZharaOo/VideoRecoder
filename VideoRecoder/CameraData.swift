//
//  CameraData.swift
//  VideoRecoder
//
//  Created by Ivan Babkin on 23.07.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

class CameraData: NSObject {
    var tempPath: String
    
    override init() {
        tempPath = String(format: "%@/%@.mov", NSTemporaryDirectory(), UUID.init().uuidString)
    }
}
