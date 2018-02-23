//
//  UserViewCell.swift
//  ChupitApp
//
//  Created by Marco Falanga on 09/02/18.
//  Copyright © 2018 Marco Falanga. All rights reserved.
//

import UIKit

class UserViewCell: UICollectionViewCell {

    @IBOutlet weak var isActiveImageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var chupitoCounterLabel: UILabel!
    @IBOutlet weak var chupitoImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()

//        let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: userImageView.frame.width+10, height: userImageView.frame.width+10))
//        
//        circle.center = userImageView.center
//        circle.layer.cornerRadius = circle.frame.width/2
//        circle.backgroundColor = .clear
//        circle.clipsToBounds = true
//        circle.layer.borderWidth = 1
//        circle.layer.borderColor = UIColor.lightGray.cgColor
//        circle.alpha = 0.5
//        
//        self.bgView.addSubview(circle)    
    }
}
