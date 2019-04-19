//
//  ConnectVC.swift
//  Ditto
//
//  Created by Melanie Cooray on 3/16/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
    var dummyLogButton: UIButton!
    var dummyProfileButton: UIButton!
    
    var connectButton: UIButton!
    
    var session: SPTSession!
    var player: SPTAudioStreamingController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "spotifyconnectback")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        //makeButtons()
        setupUI()
        
        connectButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        connectButton.center = CGPoint(x: view.frame.width/2, y: view.frame.height*2.10/3)
        connectButton.setTitle("Connect To Spotify", for: .normal)
        connectButton.addTarget(self, action: #selector(connectButtonPressed), for: .touchUpInside)
        connectButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 18)
        connectButton.backgroundColor = UIColor(hexString: "#1bb954")
        //connectButton.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .heavy)
        connectButton.layer.cornerRadius = 10
//        connectButton.layer.borderColor = UIColor(hexString: "#ffffff").cgColor
//        connectButton.layer.borderWidth = 2
        view.addSubview(connectButton)
    }
    
    
    @objc func connectButtonPressed() {
        let appURL = SPTAuth.defaultInstance().spotifyAppAuthenticationURL()!
        let webURL = SPTAuth.defaultInstance().spotifyWebAuthenticationURL()!
        
        connectButton.backgroundColor = .gray
        connectButton.setTitle("Loading...", for: .normal)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receievedUrlFromSpotify(_:)),
                                               name: NSNotification.Name.Spotify.authURLOpened,
                                               object: nil)
        
        //Check to see if the user has Spotify installed
        if SPTAuth.supportsApplicationAuthentication() {
            //Open the Spotify app by opening its url
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            //Present a web browser in the app that lets the user sign in to Spotify
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
    }
    
    @objc func receievedUrlFromSpotify(_ notification: Notification) {
        guard let url = notification.object as? URL else { return }
        
        //spotifyAuthWebView?.dismiss(animated: true, completion: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.Spotify.authURLOpened,
                                                  object: nil)
        
        SPTAuth.defaultInstance().handleAuthCallback(withTriggeredAuthURL: url) { (error, session) in
            //Check if there is an error because then there won't be a session.
            if let error = error {
                self.displayErrorMessage(error: error)
                return
            }
            
            // Check if there is a session
            if let session = session {
                print("there is a session")
                UserDefaults.standard.setValue(session.accessToken, forKey: "accessToken")
                // If there is use it to login to the audio streaming controller where we can play music.
                if self.player == nil {
                    self.player = SPTAudioStreamingController.sharedInstance()
                    if !(self.player?.loggedIn)! {
                        self.player?.delegate = self
                        self.player?.playbackDelegate = self
                        self.player?.login(withAccessToken: session.accessToken)
                    }
                }
                
            }
        }
    }
    
    func displayErrorMessage(error: Error) {
        // When changing the UI, all actions must be done on the main thread,
        // since this can be called from a notification which doesn't run on
        // the main thread, we must add this code to the main thread's queue
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error",
                                                    message: error.localizedDescription,
                                                    preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func successfulLogin() {
        // When changing the UI, all actions must be done on the main thread,
        // since this can be called from a notification which doesn't run on
        // the main thread, we must add this code to the main thread's queue
        
        DispatchQueue.main.async {
            // Present next view controller or use performSegue(withIdentifier:, sender:)
            self.performSegue(withIdentifier: "toLogin", sender: self)
            //self.present(PlaylistsViewController(), animated: true, completion: nil)
        }
    }
    
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        audioStreaming.playSpotifyURI("spotify:track:3skn2lauGk7Dx6bVIt5DVj", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if error != nil {
                print("*** failed to play: \(String(describing: error))")
                return
            }else{
                print("Playing!!")
            }
        })
        self.successfulLogin()
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didReceiveError error: Error!) {
        connectButton.backgroundColor = UIColor(red:(29.0 / 255.0), green:(185.0 / 255.0), blue:(84.0 / 255.0), alpha:1.0)
        connectButton.setTitle("Connect To Spotify", for: .normal)
        displayErrorMessage(error: error)
    }
    
}
