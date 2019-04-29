//
//  PlaylistViewCell.swift
//  Ditto
//
//  Created by Sam Lee on 4/6/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit

class PlaylistViewCell: UITableViewCell {
    
    var playlistPhoto: UIImageView!
    var playlistName: UILabel!
    var playlistLastPlayed: UILabel!
    var playButton: UIButton!
    
    var cellClicked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        // Initialization code
    }
    
    func initCellFrom(size: CGSize) {
        let oldSize = UIView(frame: CGRect(x: 0, y: 0, width: size.width/2, height: size.height/2))
        oldSize.center = CGPoint(x: size.width/6, y: size.height/2)
        
        playlistPhoto = UIImageView(frame: CGRect(x: 0, y: 0, width: size.height/2, height: size.height/2))
        playlistPhoto.center = CGPoint(x: size.width/6, y: size.height/2)
        playlistPhoto.contentMode = .scaleAspectFill
        playlistPhoto.image = UIImage(named: "genericplaylistpicture")
        contentView.addSubview(playlistPhoto)
        
        playlistName = UILabel(frame: CGRect(x: oldSize.frame.maxX * 3/4.5, y: playlistPhoto.frame.minY * 0.70, width: size.width, height: size.height/2))
        contentView.addSubview(playlistName)
        
        playlistLastPlayed = UILabel(frame: CGRect(x: oldSize.frame.maxX * 3/4.5, y: playlistName.frame.minY * 2.5, width: size.width/3, height: size.height/3))
        //playlistLastPlayed.center = CGPoint(x: playlistPhoto.frame.maxX + 18, y: size.height * 2/3)
        playlistLastPlayed.font = UIFont(name: "Roboto-Light", size: 15)
        playlistLastPlayed.layer.masksToBounds = true
        //playlistLastPlayed.text = "last played: 17h"
        playlistLastPlayed.layer.cornerRadius = 8
        contentView.addSubview(playlistLastPlayed)
        
        playButton = UIButton(frame: CGRect(x: size.width - size.width/4, y: size.height * 0.60, width: size.width/6.3, height: size.width/13.3))
        let image = UIImage(named: "playbutton")
        playButton.setImage(image, for: .normal)
        contentView.addSubview(playButton)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
