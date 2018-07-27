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
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    
    var helpCamView: UIView?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var controller: CameraController!
    
    
    //MARK: - lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller = CameraController()
        controller.delegate = self
        
        topView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        bottomView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCameraLayer(with: self.view.frame.size)
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setupCameraLayer(with: size)
    }
    
    
    //MARK: - CameraControllerDelegate methods
    
    
    func updateTimeLabel(with time: Time) {
        timeLabel.text = time.description()
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
    
    
    //MARK: - IBActions
    
    
    @IBAction func startStopRecording(_ sender: Any) {
        timeLabel.text = "00:00"
        if !controller.isRecording {
            startStopButton.setTitle("Stop", for: .normal)
            controller.startRecording()
        }
        else {
            startStopButton.setTitle("Start", for: .normal)
            controller.stopRecording()
        }
    }
    
    
    //MARK: - Setup camera layer
    
    func setupCameraLayer(with size: CGSize) {
        controller.stopCamera()
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: controller.captureSession)
        videoPreviewLayer.frame = CGRect(x: self.view.bounds.minX, y: self.view.bounds.minY, width: size.width, height: size.height)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        
        helpCamView = UIView(frame: self.view.bounds)
        helpCamView!.layer.addSublayer(videoPreviewLayer)
        self.view.addSubview(helpCamView!)
        self.view.sendSubview(toBack: helpCamView!)
        
        controller.runCamera()
    }
    
}

