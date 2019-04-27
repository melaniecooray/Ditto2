//
//  EditSongCell.swift
//  Ditto
//
//  Created by Sam Lee on 4/22/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit

class EditSongCell: UITableViewCell {
    
    var songPhoto: UIImageView!
    var songName: UILabel!
    var songArtist: UILabel!
    var swipeButton: UIButton!
    
    var cellClicked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        // Initialization code
    }
    
    func initCellFrom(size: CGSize) {
        songPhoto = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width/30, height: size.height/2))
        songPhoto.center = CGPoint(x: size.width/6, y: size.height/2)
        songPhoto.contentMode = .scaleAspectFit
        songPhoto.image = UIImage()
        contentView.addSubview(songPhoto)
        
        songName = UILabel(frame: CGRect(x: songPhoto.frame.maxX * 3/4.5, y: songPhoto.frame.minY * 0.70, width: size.width * 0.70, height: size.height/2))
        //playlistName.center = CGPoint(x: playlistPhoto.frame.maxX * 2/3, y: size.height/3)
        //        playlistName.adjustsFontSizeToFitWidth = true
        //        playlistName.font = UIFont(name: "SourceSansPro-Bold", size: 25)
        //playlistName.text = "vibe station"
        contentView.addSubview(songName)
        
        songArtist = UILabel(frame: CGRect(x: songPhoto.frame.maxX * 3/4.5, y: songName.frame.minY * 2.7, width: size.width/3, height: size.height/3))
        //playlistLastPlayed.center = CGPoint(x: playlistPhoto.frame.maxX + 18, y: size.height * 2/3)
        songArtist.font = UIFont(name: "Roboto-Light", size: 15)
        songArtist.layer.masksToBounds = true
        songArtist.text = "last played: 17h"
        songArtist.layer.cornerRadius = 8
        contentView.addSubview(songArtist)
        
        swipeButton = UIButton(frame: CGRect(x: size.width - size.width/4, y: 0, width: size.width/12, height: size.width/13.5))
        swipeButton.center = CGPoint(x: size.width - size.width/8, y: size.height/2)
        let image = UIImage(named: "swipeleft")
        swipeButton.setImage(image, for: .normal)
        contentView.addSubview(swipeButton)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

