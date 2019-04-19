//
//  CurrentPlaylistVC - UISetup.swift
//  Ditto
//
//  Created by Melanie Cooray on 4/6/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit

extension CurrentPlaylistViewController {
    
    func initUI() {
        setUpBackground()
        setUpCode()
        setUpButton()
        setUpPlaylistName()
        setUpSongImage()
        setUpSong()
        setUpControl()
    }
    
    func setUpBackground() {
        view.backgroundColor = .white
        image = UIImage(named: "88rising")
        backImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.5))
        backImage.image = image
        backImage.contentMode = .scaleAspectFill
        backImage.alpha = 0.4
        //backImage.addBlurEffect()
        view.addSubview(backImage)
    }
    
    func setUpCode() {
//        codeLabel = UILabel(frame: CGRect(x: 50, y: 50, width: view.frame.width - 100, height: 50))
//        codeLabel.text = "CODE: 67J91U"
//        codeLabel.font = UIFont(name: "Roboto-Bold", size: 30)
//        codeLabel.textColor = UIColor(hexString: "7383C5")
//        codeLabel.layer.borderColor = UIColor.black.cgColor
//        codeLabel.layer.borderWidth = CGFloat(2.0)
//        codeLabel.textAlignment = .center
//        view.addSubview(codeLabel)
        
        codeLabel = UILabel(frame: CGRect(x: view.frame.width/12, y: view.frame.height * 0.08, width: view.frame.width/3, height: view.frame.height/18))
        codeLabel.font = UIFont(name: "Roboto-Regular", size: 25)
        codeLabel.text = " C O D E: "
        codeLabel.textColor = UIColor(hexString: "#7383C5")
        codeLabel.backgroundColor = .white
        codeLabel.layer.borderColor = UIColor.clear.cgColor
        codeLabel.layer.cornerRadius = 5
        codeLabel.layer.masksToBounds = true
        codeLabel.textAlignment = .center
        view.addSubview(codeLabel)
        
        numberLabel = UILabel(frame: CGRect(x: codeLabel.frame.maxX - view.frame.width/18, y: codeLabel.frame.minY, width: view.frame.width * 0.7 - codeLabel.frame.width, height: codeLabel.frame.height))
        numberLabel.font = UIFont(name: "Roboto-Bold", size: 25)
        numberLabel.text = "  " + Utils.space(text: playlist.code) + " "
        numberLabel.textColor = UIColor(hexString: "#7383C5")
        numberLabel.layer.borderColor = UIColor.clear.cgColor
        numberLabel.layer.cornerRadius = 5
        numberLabel.layer.masksToBounds = true
        numberLabel.backgroundColor = .white
        numberLabel.textAlignment = .left
        view.addSubview(numberLabel)
        
        let borderView = UIView(frame: CGRect(x: codeLabel.frame.minX, y: codeLabel.frame.minY, width: numberLabel.frame.maxX - codeLabel.frame.minX, height: codeLabel.frame.height))
        borderView.backgroundColor = .clear
        borderView.layer.borderColor = UIColor(hexString: "#7383C5").cgColor
        borderView.layer.cornerRadius = 5
        borderView.layer.borderWidth = 2
        borderView.layer.masksToBounds = true
        view.addSubview(borderView)
    }
    
    func setUpButton() {
        barsButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.25, height: codeLabel.frame.height))
        barsButton.center = CGPoint(x: (view.frame.width + numberLabel.frame.maxX)/2 - view.frame.width/50, y: codeLabel.frame.midY)
        barsButton.setImage(UIImage(named: "bars"), for: .normal)
        barsButton.imageView?.contentMode = .scaleAspectFit
        view.addSubview(barsButton)
        
    }
    
    func setUpPlaylistName() {
        playlistName = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 2/3, height: view.frame.height/25))
        playlistName.center = CGPoint(x: view.frame.width/2, y: codeLabel.frame.maxY + view.frame.height/34)
        //playlistName.text = "\"vibe station\""
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Roboto-Bold", size: 18)
            //.backgroundColor: UIColor.white what if background is black :(
        ]
        let attribute = NSAttributedString(string: playlist.name, attributes: attributes)
        playlistName.attributedText = attribute
        //playlistName.font = UIFont(name: "Roboto-Bold", size: 18)
        playlistName.textColor = .black
        playlistName.textAlignment = .center
        playlistName.adjustsFontSizeToFitWidth = true
        view.addSubview(playlistName)
    }
    
    func setUpSongImage() {
        songImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.42, height: view.frame.width * 0.42))
        songImage.center = CGPoint(x: backImage.frame.midX, y: backImage.frame.midY + view.frame.height/26)
        songImage.image = image
        songImage.contentMode = .scaleAspectFit
        songImage.layer.shadowColor = UIColor.black.cgColor
        songImage.layer.shadowOpacity = 0.5
        songImage.layer.shadowOffset = CGSize.zero
        songImage.layer.shadowRadius = 10
        view.addSubview(songImage)
    }
    
    func setUpSong() {
        songName = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 2/3, height: view.frame.height/25))
        songName.center = CGPoint(x: view.frame.width/2, y: songImage.frame.maxY + view.frame.height/19)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Roboto-Regular", size: 16)
            //.backgroundColor: UIColor.white what if background is black :(
        ]
        let attribute = NSAttributedString(string: "Midsummer Madness", attributes: attributes)
        songName.attributedText = attribute
        songName.textColor = .black
        songName.textAlignment = .center
        songName.adjustsFontSizeToFitWidth = true
        view.addSubview(songName)
        
        artistName = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 2/3, height: view.frame.height/25))
        artistName.center = CGPoint(x: view.frame.width/2, y: songName.frame.maxY + view.frame.width * 0.01)
        let attributes2: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Roboto-Light", size: 16)
            //.backgroundColor: UIColor.white what if background is black :(
        ]
        let attribute2 = NSAttributedString(string: "88rising", attributes: attributes2)
        artistName.attributedText = attribute2
        artistName.textColor = .black
        artistName.textAlignment = .center
        artistName.adjustsFontSizeToFitWidth = true
        view.addSubview(artistName)
    }
    
    func setUpControl() {
        let items = ["Chat","Lyrics"]
        customSC = UISegmentedControl(items: items)
        customSC.frame = CGRect(x: 0, y: 0, width: 200, height: 25)
        customSC.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        customSC.selectedSegmentIndex = 0
        customSC.layer.cornerRadius = 5;
        customSC.tintColor = UIColor(hexString: "7383C5")
        view.addSubview(customSC)
    }
    
}
