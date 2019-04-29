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
import FirebaseAuth

class CurrentPlaylistViewController: UIViewController, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
    var playlist: Playlist!
    var backImage: UIImageView!
    
    var customSC: UISegmentedControl!
    var nameLabel: UILabel!
    var codeLabel: UILabel!
    var barsButton: UIButton!
    var exitButton: UIButton!
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
    let url = "https://api.spotify.com/v1/tracks/"
    
    var timer : Timer!
    var time = 0
    var player : SPTAudioStreamingController?
    
    var currentSong : String!
    var currentIndex = 0
    var first = true
    var notFirst = false
    var owner = true
    var isPlayingSong = true
    var startedPlaying = false
    
    var songs : [Song] = []
    var songList : [String] = []
    var currentLength : Int!
    
    var mstime = 0.0
    
    var ownerLabel : UILabel!
    
    var status = true
    var once = true
    var user = true
    
    typealias JSONStandard = [String : AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser?.uid != playlist.owner {
            print("not owner")
            owner = false
            isPlayingSong = false
        }
        let db = Database.database().reference()
        let playlistNode = db.child("playlists")
        playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as! [String : Any]
            var lengths = dict["lengths"] as! [Int]
            self.currentLength = lengths[self.currentIndex]
        })
        initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        listenAddedSongs()
        if self.timer != nil {
            self.timer.invalidate()
        }
        first = true
        var firstPaused = false
        var started = false
        var once = true
        if self.owner {
            findSong()
            playSong()
        } else {
            let db = Database.database().reference()
            let playlistNode = db.child("playlists")
            playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).observe(.value, with: { (snapshot) in
                let dict = snapshot.value as! [String : Any]
                let isPlayingValue = dict["isPlaying"] as! Bool
                if let currSong = dict["song"] as? Int {
                    //print(currSong)
                    //print(self.currentIndex)
                    if self.currentIndex != currSong {
                            print("updating current index")
                            self.currentIndex = currSong
                            self.player?.skipNext({ (error) in
                                if error != nil {
                                    print("error going to next song")
                                    return
                                } else {
                                    print("went to the next song")
                                    if !isPlayingValue {
                                        started = false
                                    } else {
                                        self.findSong()
                                    }
                                }
                            })
                    } else {
                        self.currentIndex = currSong
                    }
                }
                //print(self.currentIndex)
                //print(self.songs[self.currentIndex])
                if let currTime = dict["time"] as? Int {
                    //print("current time in firebase is")
                    //print(self.time)
                    self.time = currTime
                }
                
                if (isPlayingValue) {
                    //print("isPlaying is true")
                    self.ownerLabel.removeFromSuperview()
                    self.isPlayingSong = true
                    self.pause = false
                    self.once = true
                    
                    if (!self.startedPlaying) {
                        self.startedPlaying = true
                        if started {
                            self.player?.setIsPlaying(true, callback: { (error) in
                                if error != nil {
                                    print("error playing song")
                                    return
                                } else {
                                    print("playing song")
                                    //self.findSong()
                                    //self.playSong()
                                }
                            })
                        } else {
                            started = true
                            self.findSong()
                            //self.playSong()
                        }
                    } else {
                        if let currSong = dict["song"] as? Int {
                            //print(currSong)
                            //print(self.currentIndex)
                            if self.currentIndex != currSong {
                                print("updating current index")
                                self.currentIndex = currSong
                                self.player?.skipNext({ (error) in
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
                    }
                    firstPaused = true
                } else {
                    print("waiting for song to be played")
                    self.view.addSubview(self.ownerLabel)
                    if self.timer != nil {
                        self.timer.invalidate()
                    }
                    //self.pause = true
                    self.startedPlaying = false
                    if self.once {
                        self.once = false
                        self.player?.setIsPlaying(false, callback: { (error) in
                            if error != nil {
                                print("error pausing song")
                                return
                            } else {
                                print("paused song")
                            }
                        })
                    }
                }
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.player?.logout()
        self.player = nil
        if timer != nil {
            self.timer.invalidate()
        }
        if owner {
            let db = Database.database().reference()
            let playlistNode = db.child("playlists")
            playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).updateChildValues(["isPlaying" : false])
            print("is playing should befalse")
        }
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
            if let currIndex = dict["song"] as? Int {
                self.currentIndex = currIndex
            } else {
                self.currentIndex = 0
            }
            if !self.owner {
                if self.notFirst {
                    self.currentIndex += 1
                    if self.currentIndex >= songs.count {
                        self.currentIndex = 0
                    }
                }
            }
            //print(self.currentIndex)
            self.songList = songs
            self.currentSong = songs[self.currentIndex]
            //print("current song:")
            //print(self.currentSong)
            if let time = dict["time"] as? Int {
                self.time = time
                print("time is:")
                print(self.time)
                let doubleTime = Double(time)
                self.mstime = doubleTime * 1000
            }
            self.songImage.image = self.songs[self.currentIndex].image
            self.backImage.image = self.songs[self.currentIndex].image
            //self.playlistName.text = self.songs[self.currentIndex].name
            self.playlistName.text = ""
            self.artistName.text = self.songs[self.currentIndex].artist
            self.songName.text = self.songs[self.currentIndex].name
            self.currentLength = self.songs[self.currentIndex].length
            if self.first {
                self.playSong()
            } else {
                //print(self.currentIndex)
                //print(self.songs[self.currentIndex].name)
                print(self.currentSong)
                
                self.player?.playSpotifyURI(self.currentSong!, startingWith: 0, startingWithPosition: self.mstime, callback: { (error) in
                    if error != nil {
                        print("*** failed to play: \(String(describing: error))")
                        return
                    }else{
                        print("Playing!!")
                        if self.pause {
                            self.player?.setIsPlaying(true, callback: { (error) in
                                if error != nil {
                                    print("error playing song")
                                    return
                                } else {
                                    print("playing song")
                                    self.player?.setIsPlaying(false, callback: { (error) in
                                        if error != nil {
                                            print("error pausing song")
                                            return
                                        } else {
                                            print("paused song")
                                        }
                                    })
                                }
                            })
                        }
                    }
                })
            }
        })
    }
    
    func playSong() {
        

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
                    //print("player is nil")
                    self.player = SPTAudioStreamingController.sharedInstance()
                    if !(self.player?.loggedIn)! {
                        //print("player is not logged in")
                        self.player?.delegate = self
                        self.player?.playbackDelegate = self
                        self.player?.login(withAccessToken: UserDefaults.standard.value(forKey: "accessToken") as! String)
                    }
                }
                
                
            }
        }
        
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        //print("successfully logged in")
        self.player = audioStreaming
        audioStreaming.playSpotifyURI(self.currentSong!, startingWith: 0, startingWithPosition: TimeInterval(self.time), callback: { (error) in
            if error != nil {
                print("*** failed to play: \(String(describing: error))")
                return
            }else{
                print("Playing!!")
                if self.pause {
                    self.player?.setIsPlaying(true, callback: { (error) in
                        if error != nil {
                            print("error playing song")
                            return
                        } else {
                            print("playing song")
                            self.player?.setIsPlaying(false, callback: { (error) in
                                if error != nil {
                                    print("error pausing song")
                                    return
                                } else {
                                    print("paused song")
                                }
                            })
                        }
                    })
                }
                let db = Database.database().reference()
                let playlistNode = db.child("playlists")
                playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                    let dict = snapshot.value as! [String : Any]
                    if let currTime = dict["time"] as? Int {
                        self.time = currTime
                    }
                    if !self.pause {
                        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:
                        #selector(self.runTimedCode), userInfo: nil, repeats: true)
                    }
                })
            }
        })
        if self.first {
            self.first = false
            let start = self.currentIndex + 1
            for num in start..<self.songList.count {
                audioStreaming.queueSpotifyURI(self.songList[num], callback: { (error) in
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
        self.first = false
        findSong()
    }
    
    @objc func runTimedCode() {
        if self.currentIndex >= self.songs.count {
            self.currentIndex = 0
        }
        self.currentLength = self.songs[self.currentIndex].length
        self.time += 1
        let db = Database.database().reference()
        let playlistNode = db.child("playlists")
        playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as! [String : Any]

            var lengths = dict["lengths"] as! [Int]
            self.currentLength = lengths[self.currentIndex]
            if self.time > self.currentLength {
                self.notFirst = true
                self.time = 0
                self.currentIndex += 1
                if self.owner {
                    playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).updateChildValues(["song" : self.currentIndex, "time": self.time])
                }
                if self.currentIndex >= self.songs.count {
                    self.currentIndex = 0
                }
                if self.owner {
                    playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).updateChildValues(["song" : self.currentIndex, "time": self.time])
                }
                self.player?.skipNext({ (error) in
                    if error != nil {
                        print("error going to next song")
                        return
                    } else {
                        print("went to the next song")
                        self.findSong()
                    }
                })
            }
        })
        if self.owner {
            playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).updateChildValues(["song" : self.currentIndex, "time": self.time, "isPlaying" : true])
        }
    }
    
    func listenAddedSongs() {
        let db = Database.database().reference()
        let playlistNode = db.child("playlists")
        playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).observe(.value, with: {
            (snapshot) in
            let dict = snapshot.value as! [String:Any]
            let currentCount = dict["songs"] as! [String]
            if currentCount.count > self.songs.count {
                var index = self.songs.count
                let names = dict["names"] as! [String]
                let artists = dict["artists"] as! [String]
                let lengths = dict["lengths"] as! [Int]
                while index < currentCount.count {
                    self.songs.append(Song(id: currentCount[index], song: ["name" : names[index], "artists" : artists[index], "length" : lengths[index]]))
                    index += 1
                }
                
                
                
                
                let dispatchGroup = DispatchGroup()
                for (index, songuri) in currentCount.enumerated() {
                    dispatchGroup.enter()
                    let indexString = songuri.index(songuri.startIndex, offsetBy: 14)
                    let trackID = String(songuri[indexString...])
                    AF.request(self.url + trackID, headers: self.parameters).responseJSON(completionHandler: {
                        response in
                        do {
                            var track = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! JSONStandard
                            
                            if let album = track["album"] as? JSONStandard {
                                if let images = album["images"] as? [JSONStandard] {
                                    let imageData = images[0]
                                    let mainImageURL = URL(string: imageData["url"] as! String)
                                    let mainImageData = NSData(contentsOf: mainImageURL!)
                                    let mainImage = UIImage(data: mainImageData as! Data)
                                    self.songs[index].image = mainImage
                                    
                                    dispatchGroup.leave()
                                }
                            }
                        } catch {
                            print(error)
                        }
                    })
                }
                
            }
        })
    }
    
}
