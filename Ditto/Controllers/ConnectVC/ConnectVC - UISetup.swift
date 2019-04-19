//
//  ConnectVC - UISetup.swift
//  Ditto
//
//  Created by Candace Chiang on 4/6/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit

extension ConnectViewController {
    func makeButtons() {
        dummyLogButton = UIButton(frame: CGRect(x: view.frame.width/6, y: view.frame.height/15, width: view.frame.width/4, height: view.frame.height/20))
        dummyLogButton.setTitle("To Login", for: .normal)
        dummyLogButton.layer.cornerRadius = 5.0
        dummyLogButton.backgroundColor = .gray
        dummyLogButton.addTarget(self, action: #selector(toLogin), for: .touchUpInside)
        view.addSubview(dummyLogButton)
        
        dummyProfileButton = UIButton(frame: CGRect(x: view.frame.width * 4/6, y: view.frame.height/15, width: view.frame.width/4, height: view.frame.height/20))
        dummyProfileButton.setTitle("To Profile", for: .normal)
        dummyProfileButton.layer.cornerRadius = 5.0
        dummyProfileButton.backgroundColor = .gray
        dummyProfileButton.addTarget(self, action: #selector(toTabBar), for: .touchUpInside)
        view.addSubview(dummyProfileButton)
        
        let dummyConnectSpotify = UIButton(frame: CGRect(x: view.frame.width * 4/6, y: view.frame.height/2, width: view.frame.width/4, height: view.frame.height/20))
        dummyConnectSpotify.setTitle("To Spotify Connect", for: .normal)
        dummyConnectSpotify.layer.cornerRadius = 5.0
        dummyConnectSpotify.backgroundColor = .gray
        dummyConnectSpotify.addTarget(self, action: #selector(toSpotifyConnect), for: .touchUpInside)
        //view.addSubview(dummyConnectSpotify)
        print("adding dummy buttons")
    }
    
    @objc func toLogin() {
        performSegue(withIdentifier: "toLogin", sender: self)
    }
    
    @objc func toTabBar() {
        performSegue(withIdentifier: "toTabBar", sender: self)
    }
    
    @objc func toSpotifyConnect() {
        performSegue(withIdentifier: "toConnectSpotify", sender: self)
    }
    
    func setupUI() {
        let letsBeginLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2))
        letsBeginLabel.center = CGPoint(x: view.frame.width/2, y: view.frame.height*0.80/3)
        letsBeginLabel.textAlignment = .center
        letsBeginLabel.text = "Let's Begin"
        letsBeginLabel.textColor = .white 
        letsBeginLabel.font = UIFont(name: "Roboto-Regular", size: 20)
        view.addSubview(letsBeginLabel)
        
        
        
        let spotifyPhoneImage = UIImageView(frame: CGRect(x: 0, y: view.frame.height*0.5, width: view.frame.width, height: view.frame.height * 1/3))
        spotifyPhoneImage.center = CGPoint(x: view.frame.width / 2, y: view.frame.height*0.90/2)
        spotifyPhoneImage.image = UIImage(named: "spotifyconnectwhite")
        spotifyPhoneImage.contentMode = .scaleAspectFit
        view.addSubview(spotifyPhoneImage)
    }
}
