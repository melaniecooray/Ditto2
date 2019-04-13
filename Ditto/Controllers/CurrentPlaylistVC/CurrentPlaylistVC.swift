//
//  CurrentPlaylistVC.swift
//  Ditto
//
//  Created by Melanie Cooray on 3/16/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import Firebase

class CurrentPlaylistViewController: UIViewController {
    
    var image: UIImage!
    var backImage: UIImageView!
    
    var customSC: UISegmentedControl!
    var nameLabel: UILabel!
    var codeLabel: UILabel!
    var numberLabel: UILabel!
    var playlistName: UILabel!
    
    var songImage: UIImageView!

    var code: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        findSong()
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
            self.playSong(song: firstSong)
        })
    }
    
    func playSong(song: String) {
        SPTAudioStreamingController.sharedInstance().playSpotifyURI(song, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if error != nil {
                print("*** failed to play: \(String(describing: error))")
                return
            }else{
                print("Playing!!")
            }
        })
    }
    
}
