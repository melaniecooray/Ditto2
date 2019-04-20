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

class CurrentPlaylistViewController: UIViewController {
    
    var playlist: Playlist!
    var image: UIImage!
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
    
    var songImage: UIImageView!
    var bannerImage: UIImageView!
    
    var songName: UILabel!
    var artistName: UILabel!

    var code: String!
    let parameters: HTTPHeaders = ["Accept":"application/json", "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "accessToken")!)"]
    
    var timer : Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        //findSong()
        playSong()
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
            let firstSong = songs[0]
            //self.playSong(song: firstSong)
        })
    }
    
    func playSong() {
        print(playlist.id!)
        AF.request("https://api.spotify.com/v1/me/player/play", method: .put, parameters: ["context_uri" : playlist.id!],encoding: JSONEncoding.default, headers: self.parameters).responseData {
            response in
            
        }
        
        SPTAudioStreamingController.sharedInstance().playSpotifyURI(playlist.id!, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if error != nil {
                print("*** failed to play: \(String(describing: error))")
                return
            }else{
                print("Playing!!")
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: true)
            }
        })
    }
    
    @objc func runTimedCode() {
        let db = Database.database().reference()
        let playlistNode = db.child("playlists").child(playlist.code!)
        
        playlistNode.updateChildValues(["song" : 0, "time": 0, "isPlaying" : true])
    }
    
}
