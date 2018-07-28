//
//  VideosCollectionViewController.swift
//  VideoRecoder
//
//  Created by Ivan Babkin on 27.07.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit
import AVKit

private let reuseIdentifier = "Cell"

class VideosCollectionViewController: UICollectionViewController {

    var data = CameraData.getAllVideosDerictories()
    
    
    //MARK: - lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let removeVideoItem = UIMenuItem.init(title: "Delete", action: #selector(VideoCollectionViewCell.removeVideo(_:)))
        let saveToLibraryItem = UIMenuItem.init(title: "Save to library", action: #selector(VideoCollectionViewCell.saveToLibrary(_:)))
        
        UIMenuController.shared.menuItems = [removeVideoItem, saveToLibraryItem]
        
        self.collectionView!.collectionViewLayout = ColumnFlowLayout(
            cellsPerRow: 2,
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    
    // MARK: UICollectionViewDataSource

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VideoCollectionViewCell
        
        cell.controller = self
        
        if let d = try? Data.init(contentsOf: data[indexPath.row].appendingPathComponent("preview.png")) {
            cell.imageView.image = UIImage(data: d)
        }
        
        return cell
    }

    
    // MARK: UICollectionViewDelegate

    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let player = AVPlayer(url: data[indexPath.row].appendingPathComponent("\(data[indexPath.row].lastPathComponent).mov"))
        let playerController = AVPlayerViewController()
        playerController.player = player
        playerController.allowsPictureInPicturePlayback = false
        self.present(playerController, animated: true, completion: nil)
        player.play()
        
        return true
    }

    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return action == #selector(VideoCollectionViewCell.removeVideo(_:)) || action == #selector(VideoCollectionViewCell.saveToLibrary(_:))
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {}

    
    //MARK: - Menu controller actions
    
    
    @objc func removeVideo(_ sender: VideoCollectionViewCell) {
        let removeAction = UIAlertAction.init(title: "Remove", style: .default, handler: { _ in
            print("reming video \(String(describing: self.collectionView?.indexPath(for: sender)))")
            
            let indexPath = self.collectionView!.indexPath(for: sender)!
            try? CameraData.removeVideo(at: self.data[indexPath.row])
            self.data.remove(at: indexPath.row)
            self.collectionView!.deleteItems(at: [indexPath])
        })
        
        let alertController = UIAlertController.init(title: "Warning", message: "Do u really wanna delete video?", preferredStyle: .alert)
        
        alertController.addAction(removeAction)
        alertController.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }

    @objc func saveToLibrary(_ sender: VideoCollectionViewCell) {
        print("saving to library \(String(describing: collectionView?.indexPath(for: sender)))")
        let indexPath = self.collectionView!.indexPath(for: sender)!
        CameraData.saveVideoToLibrary(videoPath: data[indexPath.row].appendingPathComponent("\(data[indexPath.row].lastPathComponent).mov").path)
    }

}
