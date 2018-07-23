//
//  CameraView.swift
//  VideoRecoder
//
//  Created by Ivan Babkin on 23.07.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit
import AVKit

class CameraView: UIView {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var controller: CameraController!

    override func awakeFromNib() {
        controller = CameraController()
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: controller.captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        
        topView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        bottomView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    }
    
    override func layoutSubviews() {
        let helpCamView = UIView(frame: self.bounds)
        videoPreviewLayer.frame = self.bounds
        helpCamView.layer.addSublayer(videoPreviewLayer)
        self.addSubview(helpCamView)
        
        self.bringSubview(toFront: topView)
        self.bringSubview(toFront: bottomView)
        
        controller.runCamera()
    }
    
}
