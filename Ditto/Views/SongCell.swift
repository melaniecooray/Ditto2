//
//  SongCell.swift
//  Ditto
//
//  Created by Candace Chiang on 4/18/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit

class SongCell: UITableViewCell {
    var songImage: UIImageView!
    var label: UILabel!
    var artist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        // Initialization code
    }
    
    func initCellFrom(size: CGSize) {
        songImage = UIImageView(frame: CGRect(x: 0, y: 0, width: size.height * 2/3, height: size.height * 2/3))
        songImage.center = CGPoint(x: size.width/6, y: size.height/2)
        songImage.contentMode = .scaleAspectFit
        songImage.image = UIImage(named: "blacksquare")
        contentView.addSubview(songImage)
        
        label = UILabel(frame: CGRect(x: size.width * 0.3, y: size.height/5, width: size.width * 0.56, height: size.height/3))
        label.font = UIFont(name: "Roboto-Bold", size: 15)
        label.adjustsFontSizeToFitWidth = true
        contentView.addSubview(label)
        
        artist = UILabel(frame: CGRect(x: size.width * 0.3, y: label.frame.maxY, width: size.width * 0.56, height: size.height/4))
        artist.font = UIFont(name: "Roboto-Regular", size: 12)
        artist.adjustsFontSizeToFitWidth = true
        artist.textColor = UIColor(hexString: "7383C5")
        contentView.addSubview(artist)
    }
}
