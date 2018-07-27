//
//  ViewController.swift
//  VideoRecoder
//
//  Created by Ivan Babkin on 23.07.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices

class VideoViewController: UIViewController, CameraControllerDelegate {
    
    
    @IBOutlet weak var cameraView: CameraView!
    
    func updateTimeLabel(with time: Time) {
        cameraView.timeLabel.text = time.description()
    }
    
    func cameraController(_ controller: CameraController, didFinishRecordingTo outputFileURL: URL, error: Error?) {
        
    }
    
    func cameraController(_ controller: CameraController, didFailRecordingWithError error: Error?) {
        var alertController: UIAlertController
        if let e = error {
            alertController =  UIAlertController(title: "ERROR", message: e.localizedDescription, preferredStyle: .alert)
        }
        else {
            alertController =  UIAlertController(title: "ERROR", message: "Unknow error", preferredStyle: .alert)
        }
        
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        cameraView.controller.delegate = self
    }

}

