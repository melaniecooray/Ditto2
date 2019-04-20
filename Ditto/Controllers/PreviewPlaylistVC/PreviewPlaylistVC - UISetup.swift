//
//  PreviewPlaylistVC - UISetup.swift
//  Ditto
//
//  Created by Candace Chiang on 4/6/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit

extension PreviewPlaylistViewController {
    func setUpBackground() {
        playButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width * 3/4, height: view.frame.height * 0.22))
        playButton.center = CGPoint(x: view.frame.width/2, y: view.frame.height * 0.75)
        playButton.setImage(UIImage(named: "playlistcodebutton"), for: .normal)
        playButton.imageView?.contentMode = .scaleAspectFit
        playButton.addTarget(self, action: #selector(toPlaylist), for: .touchUpInside)
        view.addSubview(playButton)
        
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    func setUpLabels() {
//        codeLabel = UILabel(frame: CGRect(x: view.frame.width/9, y: view.frame.height * 0.28, width: view.frame.width/3, height: view.frame.height/15))
//        codeLabel.font = UIFont(name: "Roboto-Regular", size: 30)
//        codeLabel.text = " C O D E: "
//        codeLabel.textColor = UIColor(hexString: "#7383C5")
//        codeLabel.backgroundColor = .white
//        codeLabel.textAlignment = .center
//        view.addSubview(codeLabel)
        
        numberPicture = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width * 7/8, height: view.frame.height/10))
        numberPicture.center = CGPoint(x: view.frame.width/2, y: view.frame.height * 0.18)
        numberPicture.image = UIImage(named: "playlistcodeback")
        numberPicture.contentMode = .scaleAspectFill
        view.addSubview(numberPicture)
        
        numberLabel = UILabel(frame: CGRect(x: 0, y: 0, width: numberPicture.frame.width, height: numberPicture.frame.height))
        numberLabel.center = CGPoint(x: numberPicture.frame.midX, y: numberPicture.frame.midY)
        numberLabel.font = UIFont(name: "Roboto-Bold", size: 34)
        numberLabel.text = "code: " + Utils.space(text: code)
        numberLabel.textColor = .white
        numberLabel.textAlignment = .center
        view.addSubview(numberLabel)
        
        nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 3/4, height: view.frame.height/10))
        nameLabel.center = CGPoint(x: view.frame.width/2, y: view.frame.height * 0.32)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.font = UIFont(name: "Roboto-Regular", size: 40)
        nameLabel.text = playlist.name
        nameLabel.textColor = UIColor(hexString: "#7383C5")
        nameLabel.textAlignment = .center
        view.addSubview(nameLabel)
        
        liveLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width/3, height: view.frame.height/20))
        liveLabel.center = CGPoint(x: view.frame.width/2, y: nameLabel.frame.maxY + view.frame.height/12)
        liveLabel.font = UIFont(name: "Roboto-Light", size: 18)
        liveLabel.textColor = UIColor(hexString: "#7383C5")
        liveLabel.textAlignment = .center
        liveLabel.text = "Live in playlist"
        view.addSubview(liveLabel)
    }
    
    func setUpProfiles() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = view.frame.width/13
        layout.itemSize = CGSize(width: view.frame.height/12, height: view.frame.height/12)
        layout.scrollDirection = .horizontal
        scrollPics = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/12), collectionViewLayout: layout)
        scrollPics.center = CGPoint(x: view.frame.width/2, y: liveLabel.frame.maxY + view.frame.height/14)
        scrollPics.register(ProfileCell.self, forCellWithReuseIdentifier: "scrollCell")
        scrollPics.delegate = self
        scrollPics.dataSource = self
        scrollPics.contentInset = UIEdgeInsets.init(top: 0, left: view.frame.width/10, bottom: 0, right: view.frame.width/12)
        scrollPics.backgroundColor = .clear
        view.addSubview(scrollPics)
    }
}

