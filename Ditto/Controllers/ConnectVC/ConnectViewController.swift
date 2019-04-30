//
//  ConnectVC.swift
//  Ditto
//
//  Created by Melanie Cooray on 3/16/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import Firebase
import SafariServices

class ConnectViewController: UIViewController, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate, SFSafariViewControllerDelegate {
    
    var dummyLogButton: UIButton!
    var dummyProfileButton: UIButton!
    
    var connectButton: UIButton!
    
    var session: SPTSession!
    var player: SPTAudioStreamingController?
    var audioStreaming : SPTAudioStreamingController?
    
    var safari : SFSafariViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "spotifyconnectback")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        makeButtons()
        setupUI()
        
        connectButton = UIButton(frame: CGRect(x: 0, y: 0, width: 220, height: 50))
        connectButton.center = CGPoint(x: view.frame.width/2, y: view.frame.height*2.10/3)
        connectButton.setTitle("Connect To Spotify Premium", for: .normal)
        connectButton.addTarget(self, action: #selector(connectButtonPressed), for: .touchUpInside)
        connectButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
        connectButton.backgroundColor = UIColor(hexString: "#1bb954")
        connectButton.layer.cornerRadius = 10
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
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            safari = SFSafariViewController(url: webURL, configuration: config)
            //Present a web browser in the app that lets the user sign in to Spotify
            present(safari, animated: true, completion: nil)
            //UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
    }
    
    @objc func receievedUrlFromSpotify(_ notification: Notification) {
        guard let url = notification.object as? URL else { return }
        
        if safari != nil {
            safari.dismiss(animated: true, completion: {
                //spotifyAuthWebView?.dismiss(animated: true, completion: nil)
                NotificationCenter.default.removeObserver(self,
                                                          name: NSNotification.Name.Spotify.authURLOpened,
                                                          object: nil)
                UserDefaults.standard.set(url.absoluteString, forKey: "url")
                
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
            })
        } else {
            NotificationCenter.default.removeObserver(self,
                                                      name: NSNotification.Name.Spotify.authURLOpened,
                                                      object: nil)
            UserDefaults.standard.set(url.absoluteString, forKey: "url")
            
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
            self.player?.logout()
            //self.performSegue(withIdentifier: "toLogin", sender: self)
            //self.present(PlaylistsViewController(), animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let resultVC = segue.destination as? LoginViewController {
            resultVC.player = self.audioStreaming
        }
    }
    
    func audioStreamingDidLogout(_ audioStreaming: SPTAudioStreamingController!) {
        print("after logout")
        //try! self.player?.stop()
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                print("logged in")
                UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "id")
                self.performSegue(withIdentifier: "connectedLogin", sender: self)
            } else {
                print("going to login screen")
                DispatchQueue.main.async {
                    self.getTopMostViewController()?.performSegue(withIdentifier: "toLogin", sender: self)
                }
            }
        }
    }
    
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        connectButton.backgroundColor = .gray
        connectButton.setTitle("Loading...", for: .normal)
        self.audioStreaming = audioStreaming
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
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        
        return topMostViewController
    }
    
}
