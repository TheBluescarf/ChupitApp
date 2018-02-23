//
//  PhotoCell.swift
//  ChupitApp
//
//  Created by Marco Falanga on 21/02/18.
//  Copyright © 2018 Marco Falanga. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    var imageName: String! {
        didSet {
            photoImageView.image = UIImage(named: imageName)
        }
    }
    
    
    
    override var isSelected: Bool {
        didSet {
            photoImageView.layer.borderWidth = isSelected ? 2 : 0
        }
    }
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.layer.borderColor = UIColor.myOrange.cgColor
        isSelected = false
    }
    
    
}
