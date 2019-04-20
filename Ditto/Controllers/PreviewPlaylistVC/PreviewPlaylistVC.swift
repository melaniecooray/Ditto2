
//
//  PreviewPlaylistVCViewController.swift
//  Ditto
//
//  Created by Candace Chiang on 4/6/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import Firebase

class PreviewPlaylistViewController: UIViewController, UIScrollViewDelegate {
    
    var code: String!
    var playlist: Playlist!
    
    var playButton: UIButton!
    var scrollPics: UICollectionView!
    
    var nameLabel: UILabel!
    //var codeLabel: UILabel!
    var numberPicture: UIImageView!
    var numberLabel: UILabel!
    var liveLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackground()
        setUpLabels()
        setUpProfiles()
        // Do any additional setup after loading the view.
    }
    
    @objc func toPlaylist(_ sender: UIButton) {
        let db = Database.database().reference()
        let playlistNode = db.child("playlists").child(code)
        playlistNode.updateChildValues(["playing" : true, "song" : 0, "time": 0])
        performSegue(withIdentifier: "toPlaylist", sender: self)
        //let currentVC = CurrentPlaylistViewController()
        //currentVC.code = code
        //present(currentVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let currentVC = segue.destination as? CurrentPlaylistViewController {
            currentVC.code = code
            currentVC.playlist = playlist
        }
    }
}

