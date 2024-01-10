//
//  PhotoCollectionViewCell.swift
//  Photosgallery
//
//  Created by Terry Jason on 2024/1/6.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 20.0
            imageView.clipsToBounds = true
        }
    }
    
}
