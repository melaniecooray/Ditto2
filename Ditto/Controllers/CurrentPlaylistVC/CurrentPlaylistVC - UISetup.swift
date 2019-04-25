//
//  CurrentPlaylistVC - UISetup.swift
//  Ditto
//
//  Created by Melanie Cooray on 4/6/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

extension CurrentPlaylistViewController {
    
    func initUI() {
        setUpBackground()
        setUpBanner()
        setUpCode()
        setUpButton()
        setUpSongImage()
        setUpPlaylistName()
        setUpSong()
        setUpNavBar()
        //setUpControl()
        if Auth.auth().currentUser?.uid == playlist.owner {
            view.addSubview(playbutton)
            view.addSubview(rightButton)
            view.addSubview(leftButton)
        }
    }
    
    func setUpBackground() {
        view.backgroundColor = .white
        backImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.65))
        backImage.image = songs[currentIndex].image
        backImage.contentMode = .scaleAspectFill
        backImage.alpha = 0.4
        //backImage.addBlurEffect()
        view.addSubview(backImage)
    }
    
    func setUpBanner() {
        bannerImage = UIImageView(frame: CGRect(x: 0, y: backImage.frame.maxY * 0.95, width: view.frame.width, height: view.frame.height / 7))
        bannerImage.contentMode = .scaleToFill
        bannerImage.image = UIImage(named: "playlistcodeback")
        view.addSubview(bannerImage)
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
        
        codeLabel = UILabel(frame: CGRect(x: view.frame.width/8, y: view.frame.height * 0.08, width: view.frame.width/3, height: view.frame.height/18))
        codeLabel.font = UIFont(name: "Roboto-Regular", size: 25)
        codeLabel.text = "C O D E: "
        codeLabel.textColor = UIColor(hexString: "#7383C5")
        codeLabel.backgroundColor = .white
        codeLabel.layer.borderColor = UIColor.clear.cgColor
        codeLabel.layer.cornerRadius = 5
        codeLabel.layer.masksToBounds = true
        codeLabel.textAlignment = .center
        view.addSubview(codeLabel)
        
        numberLabel = UILabel(frame: CGRect(x: codeLabel.frame.maxX - view.frame.width/16.5, y: codeLabel.frame.minY, width: view.frame.width * 0.7 - codeLabel.frame.width, height: codeLabel.frame.height))
        numberLabel.font = UIFont(name: "Roboto-Bold", size: 25)
        numberLabel.text = Utils.space(text: playlist.code) + " "
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
        barsButton.addTarget(self, action: #selector(editPressed), for: .touchUpInside)
        view.addSubview(barsButton)
        
    }
    
    @objc func editPressed() {
        self.tabBarController?.selectedIndex = 1
        let navController = self.tabBarController?.viewControllers![1] as! UINavigationController
        let resultVC = EditPlaylistViewController()
//        resultVC.code = UserDefaults.standard.value(forKey: "code") as! String
//        resultVC.playlist = Playlist(id: playlistID!, playlist: ["name": name, "code": UserDefaults.standard.value(forKey: "code"), "songs": selectedSongs])
        navController.pushViewController(resultVC, animated: true)
    }
    
    func setUpPlaylistName() {
        playlistName = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 2/3, height: view.frame.height/25))
        playlistName.center = CGPoint(x: view.frame.width/2, y: songImage.frame.minY - view.frame.height/26)
        //playlistName.text = playlist.name
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
        songImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.6, height: view.frame.width * 0.6))
        songImage.center = CGPoint(x: backImage.frame.midX, y: backImage.frame.midY + view.frame.height/20)
        songImage.image = songs[currentIndex].image
        songImage.contentMode = .scaleAspectFit
        songImage.layer.shadowColor = UIColor.black.cgColor
        songImage.layer.shadowOpacity = 0.5
        songImage.layer.shadowOffset = CGSize.zero
        songImage.layer.shadowRadius = 10
        view.addSubview(songImage)
    }
    
    func setUpSong() {
        let nowPlayingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 2/3, height: view.frame.height/25))
        nowPlayingLabel.center = CGPoint(x: view.frame.width/2, y: songImage.frame.maxY + view.frame.height/9.5)
        nowPlayingLabel.textAlignment = .center
        nowPlayingLabel.textColor = .white
        nowPlayingLabel.text = playlist.name
        nowPlayingLabel.font = UIFont(name: "Roboto-Bold", size: 16)
        view.addSubview(nowPlayingLabel)
        
        
        
        //added
        songName = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 2/3, height: view.frame.height/25))
        songName.center = CGPoint(x: view.frame.width/2, y: bannerImage.frame.maxY * 0.9)
        //playlistName.text = "\"vibe station\""
        songName.text = songs[currentIndex].name
        songName.font = UIFont(name: "Roboto-Regular", size: 18)
        songName.textColor = .white
        songName.textAlignment = .center
        songName.adjustsFontSizeToFitWidth = true
        view.addSubview(songName)
        
        //added
//        songName = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 2/3, height: view.frame.height/25))
//        songName.center = CGPoint(x: view.frame.width/2, y: songImage.frame.maxY + view.frame.height/10)
//        let attributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont(name: "Roboto-Regular", size: 16)
//            //.backgroundColor: UIColor.white what if background is black :(
//        ]
//        let attribute = NSAttributedString(string: playlist.name, attributes: attributes)
//        songName.attributedText = attribute
//        songName.textColor = .white
//        songName.center = CGPoint(x: bannerImage.frame.maxX/2, y: bannerImage.frame.maxY/4)
//        songName.textAlignment = .center
//        songName.adjustsFontSizeToFitWidth = true
//        view.addSubview(songName)
        
        artistName = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 2/3, height: view.frame.height/25))
        artistName.center = CGPoint(x: view.frame.width/2, y: songName.frame.maxY + view.frame.width * 0.01)
        artistName.text = songs[currentIndex].artist
        artistName.textColor = .white
        artistName.center = CGPoint(x: bannerImage.frame.maxX/2, y: bannerImage.frame.maxY * 0.95)
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
    
    func setUpNavBar() {
        playbutton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width/4, height: view.frame.height/7))
        playbutton.center = CGPoint(x: view.frame.width/2, y: view.frame.width * 1.49)
        playbutton.setImage(UIImage(named: "playlistpausebutton"), for: .normal)
        playbutton.contentMode = .scaleAspectFill
        playbutton.addTarget(self, action: #selector(pausePressed), for: .touchUpInside)
        //view.addSubview(playbutton)
        
        rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width/4, height: view.frame.height/7))
        rightButton.center = CGPoint(x: view.frame.width*0.75, y: view.frame.width * 1.49)
        rightButton.setImage(UIImage(named: "playlisrightbutton"), for: .normal)
        rightButton.contentMode = .scaleAspectFill
        rightButton.addTarget(self, action: #selector(goForward), for: .touchUpInside)
        //view.addSubview(rightButton)
        
        leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width/4, height: view.frame.height/7))
        leftButton.center = CGPoint(x: view.frame.width/4, y: view.frame.width * 1.49)
        leftButton.setImage(UIImage(named: "playlistleftbutton"), for: .normal)
        leftButton.contentMode = .scaleAspectFill
        leftButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        //view.addSubview(leftButton)
        
        
    }
    
    @objc func pausePressed() {
        if pause  {
            playbutton.setImage(UIImage(named: "playlistpausebutton"), for: .normal)
            pause = false
            player?.setIsPlaying(true, callback:{ (error) in
                if error != nil {
                    print("error playing song")
                    return
                } else {
                    print("playing song")
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: true)
                }
            })
        } else {
            playbutton.setImage(UIImage(named: "playlistcodebutton"), for: .normal)
            pause = true
            player?.setIsPlaying(false, callback: { (error) in
                if error != nil {
                    print("error pausing song")
                    return
                } else {
                    print("paused song")
                    self.timer.invalidate()
                    let db = Database.database().reference()
                    let playlistNode = db.child("playlists").child(self.playlist.code!)
                    playlistNode.updateChildValues(["isPlaying" : false])
                }
            })
        }
    }
    
    @objc func goBack() {
        self.currentIndex -= 1
        player?.skipPrevious({ (error) in
            if error != nil {
                print("error going to previous song!")
                return
            } else {
                print("went to the previous song")
                self.findSong()
            }
            })
    }
    
    @objc func goForward() {
        self.currentIndex += 1
        player?.skipNext({ (error) in
            if error != nil {
                print("error going to next song")
                return
            } else {
                print("went to the next song")
                self.findSong()
            }
            })
    }
}
