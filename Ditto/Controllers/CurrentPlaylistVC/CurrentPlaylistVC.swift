//
//  CurrentPlaylistVC.swift
//  Ditto
//
//  Created by Melanie Cooray on 3/16/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import SwiftyJSON
import FirebaseDatabase

class CurrentPlaylistViewController: UIViewController, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
    var playlist: Playlist!
    var backImage: UIImageView!
    
    var customSC: UISegmentedControl!
    var nameLabel: UILabel!
    var codeLabel: UILabel!
    var barsButton: UIButton!
    var playbutton: UIButton!
    var rightButton: UIButton!
    var leftButton: UIButton!
    
    
    var pause = false
    
    var numberLabel: UILabel!
    var playlistName: UILabel!
    var nowPlayingLabel: UILabel!
    
    var songImage: UIImageView!
    var bannerImage: UIImageView!
    
    var songName: UILabel!
    var artistName: UILabel!

    var code: String!
    let parameters: HTTPHeaders = ["Accept":"application/json", "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "accessToken")!)"]
    
    var timer : Timer!
    var time = 0
    var player : SPTAudioStreamingController?
    
    var currentSong : String!
    var currentIndex = 0
    var first = true
    
    var songs : [Song] = []
    var songList : [String] = []
    
    typealias JSONStandard = [String : AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        findSong()
        playSong()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.player?.logout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func findSong() {
        let db = Database.database().reference()
        let playlistNode = db.child("playlists")
        playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as! [String : Any]
            let songs = dict["songs"] as! [String]
            self.songList = songs
            self.currentSong = songs[self.currentIndex]
            if self.first {
                self.playSong()
            } else {
                print(self.currentIndex)
                print(self.songs[self.currentIndex].name)
                self.nowPlayingLabel.text = self.songs[self.currentIndex].name
                self.songImage.image = self.songs[self.currentIndex].image
                self.backImage.image = self.songs[self.currentIndex].image
                //self.playlistName.text = self.songs[self.currentIndex].name
                self.artistName.text = self.songs[self.currentIndex].artist
                self.songName.text = self.songs[self.currentIndex].name
                self.player?.playSpotifyURI(self.currentSong, startingWith: 0, startingWithPosition: 0, callback: { (error) in
                    if error != nil {
                        print("*** failed to play: \(String(describing: error))")
                        return
                    }else{
                        print("Playing!!")
                    }
                })
            }
        })
    }
    
    func playSong() {
        print("printing playlist id")
        print(playlist.id!)
        /*
        AF.request("https://api.spotify.com/v1/me/player/play", method: .put, parameters: ["context_uri" : playlist.id!, "offset" : ["position" : 0], "position_ms" : 0],encoding: JSONEncoding.default, headers: self.parameters).responseData {
            response in
            switch response.result {
            case.success:
                print("success! playing playlist")
            case.failure(let error):
                print(error)
                
            }
            
        }
 */
        

        SPTAuth.defaultInstance().handleAuthCallback(withTriggeredAuthURL: URL(string: UserDefaults.standard.value(forKey: "url") as! String)) { (error, session) in
            //Check if there is an error because then there won't be a session.
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            // Check if there is a session
            if let session = session {
                print("there is a session")
                //UserDefaults.standard.setValue(session.accessToken, forKey: "accessToken")
                // If there is use it to login to the audio streaming controller where we can play music.
                
                if self.player == nil {
                    print("player is nil")
                    self.player = SPTAudioStreamingController.sharedInstance()
                    if !(self.player?.loggedIn)! {
                        print("player is not logged in")
                        self.player?.delegate = self
                        self.player?.playbackDelegate = self
                        self.player?.login(withAccessToken: UserDefaults.standard.value(forKey: "accessToken") as! String)
                    }
                }
                
                
            }
        }
        
        
        /*
        SPTAudioStreamingController.sharedInstance().playSpotifyURI(playlist.id!, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if error != nil {
                print("*** failed to play: \(String(describing: error))")
                return
            }else{
                print("Playing!!")
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: true)
            }
        })
 */
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        print("successfully logged in")
        self.player = audioStreaming
        audioStreaming.playSpotifyURI(currentSong, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if error != nil {
                print("*** failed to play: \(String(describing: error))")
                return
            }else{
                print("Playing!!")
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: true)
            }
        })
        if first {
            first = false
            let start = currentIndex + 1
            for num in start..<songList.count {
                audioStreaming.queueSpotifyURI(songList[num], callback: { (error) in
                    if error != nil {
                        print("*** failed to queue: \(String(describing: error))")
                        return
                    }else{
                        print("Added to Queue!!")
                    }
                })
            }
        }
        
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didReceiveError error: Error!) {
        print("ERROR:")
        print(error.localizedDescription)
    }
    
    @objc func runTimedCode() {
        self.time += 1
        let db = Database.database().reference()
        let playlistNode = db.child("playlists").child(playlist.code!)
        isPlaying()
        playlistNode.updateChildValues(["song" : self.currentIndex, "time": self.time, "isPlaying" : true])
    }
    
    func isPlaying() {
        AF.request("https://api.spotify.com/v1/me/player", headers: self.parameters).responseData {
            response in
            do {
                var readableJSON = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! JSONStandard
                print(readableJSON)
                if let result = readableJSON["is_playing"] {
                    if (result as! Bool) == false {
                        print("found false")
                        self.currentIndex += 1
                        self.findSong()
                    }
                }
            }catch{
                print(error)
            }
            
        }
    }
    
}
