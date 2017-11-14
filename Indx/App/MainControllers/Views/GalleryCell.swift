//
//  GalleryCell.swift
//  Indx
//
//  Created by Mazyad Alabduljaleel on 10/14/16.
//  Copyright © 2016 level3. All rights reserved.
//

import UIKit
import Kingfisher


class GalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    
    var galleryItem: GalleryItem? {
        didSet { updateContent() }
    }
    
    private func updateContent() {
        
        guard let item = galleryItem else {
            return
        }
        
        nameLabel.text = item.name.value
        previewImageView.kf.setImage(with: item.imageURL)
    }
}
