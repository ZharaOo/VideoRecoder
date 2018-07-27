//
//  CameraController.swift
//  VideoRecoder
//
//  Created by Ivan Babkin on 23.07.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit
import AVKit

protocol CameraControllerDelegate: class {
    func cameraController(_ controller: CameraController, didFinishRecordingTo outputDirectoryURL: URL, error: Error?)
    func cameraController(_ controller: CameraController, didFailRecordingWithError error: Error?)
    func updateTimeLabel(with time: Time)
}

class CameraController: NSObject, AVCaptureFileOutputRecordingDelegate {
    var captureSession: AVCaptureSession!
    var movieOutputFile: AVCaptureMovieFileOutput!
    var cameraData: CameraData!
    var isRecording = false
    
    var time: Time?
    var timer: Timer?
    
    weak var delegate: CameraControllerDelegate?
    
    
    //MARK: - initializator
    
    
    override init() {
        super.init()
        if let (vDeviceInput, aDeviceInput, mFileOutput) = prepareForSessionCreation() {
            self.captureSession = createCaptureSession(videoDeviceInput: vDeviceInput, audioDeviceInput: aDeviceInput, videoFileOutput: mFileOutput) as AVCaptureSession?
            
            if captureSession.canSetSessionPreset(.hd1280x720) {
                captureSession.sessionPreset = .hd1280x720
            }
            
            self.movieOutputFile = mFileOutput
        }
    }
    
    //MARK: - AVCaptureFileOutputRecordingDelegate
    
    internal func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if FileManager.default.fileExists(atPath: cameraData.tempPath) {
            do {
                let dUrl = try cameraData.saveVideoLocaly()
                delegate?.cameraController(self, didFinishRecordingTo: dUrl, error: error)
            }
            catch {
                delegate?.cameraController(self, didFailRecordingWithError: error)
            }
        }
        else {
            delegate?.cameraController(self, didFailRecordingWithError: error)
        }
        
        stopRecording()
    }
    
    //MARK: - Prepare camera methods
    
    private func createCaptureSession(videoDeviceInput: AVCaptureDeviceInput, audioDeviceInput: AVCaptureDeviceInput, videoFileOutput: AVCaptureMovieFileOutput) -> AVCaptureSession? {
        let captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        
        if captureSession.canAddInput(videoDeviceInput) && captureSession.canAddInput(audioDeviceInput) && captureSession.canAddOutput(videoFileOutput) {
            captureSession.addInput(videoDeviceInput)
            captureSession.addInput(audioDeviceInput)
            captureSession.addOutput(videoFileOutput)
            
            captureSession.commitConfiguration()
            
            return captureSession
        }
        else {
            return nil
        }
    }
    
    private func prepareForSessionCreation() -> (AVCaptureDeviceInput, AVCaptureDeviceInput, AVCaptureMovieFileOutput)? {
        var videoDeviceInput: AVCaptureDeviceInput!
        var audioDeviceInput: AVCaptureDeviceInput!
        
        if let videoDevice = AVCaptureDevice.default(for: .video) {
            do {
                videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice) as AVCaptureDeviceInput
            }
            catch {
                print(error)
                return nil
            }
        }
        
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            do {
                audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice) as AVCaptureDeviceInput
            }
            catch {
                print(error)
                return nil
            }
        }
        
        let movieFileOutput = AVCaptureMovieFileOutput()
        movieFileOutput.maxRecordedDuration = CMTimeMakeWithSeconds(60 * 5, 30)
        movieFileOutput.maxRecordedFileSize = 160 * 1024 * 1024
        movieFileOutput.minFreeDiskSpaceLimit = 1024 * 1024
        
        return (videoDeviceInput, audioDeviceInput, movieFileOutput)
    }
    
    //MARK: - Recording Methods
    
    func runCamera() {
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    func stopCamera()  {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    func startRecording() {
        cameraData = CameraData()
        movieOutputFile.startRecording(to: cameraData.tempURL, recordingDelegate: self)
        isRecording = true
        startTimer()
    }
    
    func stopRecording() {
        movieOutputFile.stopRecording()
        isRecording = false
        stopTimer()
    }
    
    
    //MARK: - Timer methods
    
    
    private func startTimer() {
        time = Time()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        time = nil
    }
    
    @objc private func timerTick() {
        if let t = time {
            t.increaseBySecond()
            delegate?.updateTimeLabel(with: t)
        }
    }
    
}
