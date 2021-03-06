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
import FirebaseAuth
import FirebaseDatabase

extension CurrentPlaylistViewController {
    
    func initUI() {
        setUpBackground()
        setUpBanner()
        setUpCode2()
        setUpButton()
        setUpSongImage()
        setUpPlaylistName()
        setUpSong()
        setUpNavBar()
        setupOwnerLabel()
        if Auth.auth().currentUser?.uid == playlist.owner {
            view.addSubview(playbutton)
            view.addSubview(rightButton)
            view.addSubview(leftButton)
        }
    }
    
    func setUpBackground() {
        view.backgroundColor = .white
        backImage = UIImageView(frame: CGRect(x: 0, y: view.frame.height/8, width: view.frame.width, height: view.frame.height * 0.65 - view.frame.height/8))
        backImage.contentMode = .scaleAspectFill
        backImage.alpha = 0.5
        view.addSubview(backImage)
    }
    
    func setUpBanner() {
        bannerImage = UIImageView(frame: CGRect(x: 0, y: backImage.frame.maxY * 0.95, width: view.frame.width, height: view.frame.height / 7))
        bannerImage.contentMode = .scaleToFill
        bannerImage.image = UIImage(named: "playlistcodeback")
        view.addSubview(bannerImage)
    }
    
    func setUpCode() {
        
        codeLabel = UILabel(frame: CGRect(x: view.frame.width/6, y: view.frame.height * 0.08, width: view.frame.width/3, height: view.frame.height/18))
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
    
    func setUpCode2() {
        codeLabel = UILabel(frame: CGRect(x: view.frame.width/11, y: view.frame.height * 0.04, width: view.frame.width * 0.75, height: view.frame.height/18))
        codeLabel.font = UIFont(name: "Roboto-Bold", size: 25)
        codeLabel.text = "code: " + Utils.space(text: playlist.code)
        codeLabel.textColor = UIColor(hexString: "#7383C5")
        codeLabel.layer.borderColor = UIColor.clear.cgColor
        codeLabel.textAlignment = .center
        view.addSubview(codeLabel)
    }
    
    func setUpButton() {
        barsButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.11, height: view.frame.width * 0.11))
        //barsButton.center = CGPoint(x: (view.frame.width + codeLabel.frame.maxX)/2 - view.frame.width/30, y: codeLabel.frame.midY)
        barsButton.center = CGPoint(x: view.frame.width * 0.9 , y: codeLabel.frame.midY)
        barsButton.setImage(UIImage(named: "bars"), for: .normal)
        barsButton.imageView?.contentMode = .scaleAspectFit
        barsButton.addTarget(self, action: #selector(editPressed), for: .touchUpInside)
        if user {
            view.addSubview(barsButton)
        }
        exitButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.06, height: view.frame.width * 0.06))
        exitButton.center = CGPoint(x: view.frame.width / 14, y: codeLabel.frame.midY)
        exitButton.setImage(UIImage(named: "x"), for: .normal)
        exitButton.imageView?.contentMode = .scaleAspectFit
        exitButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
        view.addSubview(exitButton)
    }
    
    @objc func exit() {
        self.isPlayingSong = false
        first = true
        self.player?.logout()
        if self.timer != nil {
            self.timer.invalidate()
        }
        if user {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.performSegue(withIdentifier: "returnToLogin", sender: self)
        }
    }
    
    @objc func editPressed() {
        self.isPlayingSong = false
        first = true
        self.player?.logout()
        if self.timer != nil {
            self.timer.invalidate()
        }
        let resultVC = EditPlaylistViewController()
        
        resultVC.songs = songs
        resultVC.player = player
        resultVC.pause = pause
        resultVC.playlist = playlist
        resultVC.owner = owner
        self.tabBarController?.selectedIndex = 1
        let navController = self.tabBarController?.viewControllers![1] as! UINavigationController
        navController.setNavigationBarHidden(false, animated: .init())
        navController.pushViewController(resultVC, animated: true)
    }
    
    func setUpPlaylistName() {
        playlistName = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 2/3, height: view.frame.height/25))
        playlistName.center = CGPoint(x: view.frame.width/2, y: songImage.frame.minY - view.frame.height/26)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Roboto-Bold", size: 18)
            //.backgroundColor: UIColor.white what if background is black :(
        ]
        let attribute = NSAttributedString(string: playlist.name, attributes: attributes)
        playlistName.attributedText = attribute
        playlistName.textColor = .black
        playlistName.textAlignment = .center
        playlistName.adjustsFontSizeToFitWidth = true

    }
    
    func setUpSongImage() {
        songImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.6, height: view.frame.width * 0.6))
        songImage.center = CGPoint(x: backImage.frame.midX, y: backImage.frame.midY - view.frame.height/50)
        songImage.contentMode = .scaleAspectFit
        songImage.layer.shadowColor = UIColor.black.cgColor
        songImage.layer.shadowOpacity = 0.5
        songImage.layer.shadowOffset = CGSize.zero
        songImage.layer.shadowRadius = 10
        view.addSubview(songImage)
    }
    
    func setUpSong() {
        nowPlayingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 2/3, height: view.frame.height/25))
        nowPlayingLabel.center = CGPoint(x: view.frame.width/2, y: songImage.frame.maxY + view.frame.height/9.1)
        nowPlayingLabel.textAlignment = .center
        nowPlayingLabel.textColor = .white
        nowPlayingLabel.text = playlist.name
        nowPlayingLabel.font = UIFont(name: "Roboto-Bold", size: 16)
        view.addSubview(nowPlayingLabel)
        
        songName = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 2/3, height: view.frame.height/25))
        songName.center = CGPoint(x: view.frame.width/2, y: bannerImage.frame.maxY * 0.9)
        songName.font = UIFont(name: "Roboto-Regular", size: 18)
        songName.textColor = .white
        songName.textAlignment = .center
        songName.adjustsFontSizeToFitWidth = true
        view.addSubview(songName)
        
        artistName = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 2/3, height: view.frame.height/25))
        artistName.center = CGPoint(x: view.frame.width/2, y: songName.frame.maxY + view.frame.width * 0.01)
        artistName.textColor = .white
        artistName.center = CGPoint(x: bannerImage.frame.maxX/2, y: bannerImage.frame.maxY * 0.95)
        artistName.textAlignment = .center
        artistName.adjustsFontSizeToFitWidth = true
        artistName.font = UIFont(name: "Roboto-Regular", size: 15)
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
        if pause {
            playbutton.setImage(UIImage(named: "playlistcodebutton"), for: .normal)
        } else {
            playbutton.setImage(UIImage(named: "playlistpausebutton"), for: .normal)
        }
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
    
    func setupOwnerLabel() {
        ownerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/20))
        ownerLabel.center = CGPoint(x: view.frame.width/2, y: artistName.frame.maxY * 1.12)
        ownerLabel.font = UIFont(name: "Roboto-Bold", size: 20)
        ownerLabel.textAlignment = .center
        ownerLabel.textColor = UIColor(hexString: "#7383C5")
        ownerLabel.text = "Owner hasn't pressed play"
    }
    
    @objc func pausePressed() {
        if pause  {
            playbutton.setImage(UIImage(named: "playlistpausebutton"), for: .normal)
            pause = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.player?.setIsPlaying(true, callback:{ (error) in
                    if error != nil {
                        print("error playing song")
                        return
                    } else {
                        print("playing song")
                        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: true)
                    }
                })
            }
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
        self.mstime = 0.0
        self.time = 0
        let db = Database.database().reference()
        let playlistNode = db.child("playlists")
        if self.currentIndex < 0 {
            self.currentIndex = 0
        }
        playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).updateChildValues(["time" : 0, "song" : self.currentIndex])
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
        self.mstime = 0.0
        self.time = 0
        let db = Database.database().reference()
        let playlistNode = db.child("playlists")
        if self.currentIndex >= self.songs.count {
            self.currentIndex = 0
        }
        playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).updateChildValues(["time" : 0, "song" : self.currentIndex])
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let resultVC = segue.destination as? EditPlaylistViewController {
            resultVC.songs = songs
            resultVC.player = player
            resultVC.pause = pause
            resultVC.playlist = playlist
            resultVC.owner = owner
        }
    }
}
