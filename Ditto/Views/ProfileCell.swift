//
//  ProfileCell.swift
//  Ditto
//
//  Created by Candace Chiang on 4/11/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    var profilePic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let size = contentView.frame.size
        profilePic = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        profilePic.center = CGPoint(x: size.width/2, y: size.height/2)
        profilePic.contentMode = .scaleAspectFit
        profilePic.setRounded()
        contentView.addSubview(profilePic)
    }
}

