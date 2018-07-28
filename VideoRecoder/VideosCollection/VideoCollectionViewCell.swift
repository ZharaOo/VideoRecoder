//
//  VideoCollectionViewCell.swift
//  VideoRecoder
//
//  Created by Ivan Babkin on 28.07.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    weak var controller: VideosCollectionViewController?
    
    
    //MARK: - lifecycle
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
    }
    
    
    //MARK: - Actions for menu controller
    
    
    @objc func removeVideo(_ sender: Any) {
        controller?.removeVideo(self)
    }
    
    @objc func saveToLibrary(_ sender: Any) {
        controller?.saveToLibrary(self)
    }
    
}
