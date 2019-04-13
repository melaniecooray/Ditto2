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
        colorBlock = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 3/4))
        colorBlock.backgroundColor = UIColor(hexString: "#7383C5")
        view.addSubview(colorBlock)
        
        playButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width/3, height: view.frame.height/8))
        playButton.center = CGPoint(x: view.frame.width/2, y: colorBlock.frame.maxY)
        playButton.setImage(UIImage(named: "playPreview"), for: .normal)
        playButton.imageView?.contentMode = .scaleAspectFit
        playButton.addTarget(self, action: #selector(toPlaylist), for: .touchUpInside)
        view.addSubview(playButton)
    }
    
    func setUpLabels() {
        nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 3/4, height: view.frame.height/10))
        nameLabel.center = CGPoint(x: view.frame.width/2, y: view.frame.height * 0.21)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.font = UIFont(name: "Roboto-Bold", size: 48)
        nameLabel.text = "vibe station"
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        view.addSubview(nameLabel)
        
        codeLabel = UILabel(frame: CGRect(x: view.frame.width/9, y: view.frame.height * 0.28, width: view.frame.width/3, height: view.frame.height/15))
        codeLabel.font = UIFont(name: "Roboto-Regular", size: 30)
        codeLabel.text = " C O D E: "
        codeLabel.textColor = UIColor(hexString: "#7383C5")
        codeLabel.backgroundColor = .white
        codeLabel.textAlignment = .center
        view.addSubview(codeLabel)
        
        numberLabel = UILabel(frame: CGRect(x: codeLabel.frame.maxX, y: codeLabel.frame.minY, width: view.frame.width * 0.78 - codeLabel.frame.width, height: codeLabel.frame.height))
        numberLabel.font = UIFont(name: "Roboto-Bold", size: 30)
        numberLabel.text = "  " + Utils.space(text: code)
        numberLabel.textColor = UIColor(hexString: "#7383C5")
        numberLabel.backgroundColor = .white
        numberLabel.textAlignment = .left
        view.addSubview(numberLabel)
        
        liveLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width/3, height: view.frame.height/20))
        liveLabel.center = CGPoint(x: view.frame.width/2, y: codeLabel.frame.maxY + view.frame.height/7)
        liveLabel.font = UIFont(name: "Roboto-Regular", size: 20)
        liveLabel.textColor = .white
        liveLabel.textAlignment = .center
        liveLabel.text = "listening now"
        view.addSubview(liveLabel)
    }
    
    func setUpProfiles() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = view.frame.width/10
        layout.itemSize = CGSize(width: view.frame.height/16, height: view.frame.height/16)
        layout.scrollDirection = .horizontal
        scrollPics = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/16), collectionViewLayout: layout)
        scrollPics.center = CGPoint(x: view.frame.width/2, y: liveLabel.frame.maxY + view.frame.height/14)
        scrollPics.register(ProfileCell.self, forCellWithReuseIdentifier: "scrollCell")
        scrollPics.delegate = self
        scrollPics.dataSource = self
        scrollPics.contentInset = UIEdgeInsets.init(top: 0, left: view.frame.width/12, bottom: 0, right: view.frame.width/12)
        scrollPics.backgroundColor = .clear
        view.addSubview(scrollPics)
    }
}

