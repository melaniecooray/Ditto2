
//
//  PreviewPlaylistVCViewController.swift
//  Ditto
//
//  Created by Candace Chiang on 4/6/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import FirebaseDatabase

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
    
    var memberPics: [UIImage] = []
    
    var guest = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackground()
        setUpLabels()
        getMembers()
        // Do any additional setup after loading the view.
    }
    
    @objc func toPlaylist(_ sender: UIButton) {
        let db = Database.database().reference()
        let playlistNode = db.child("playlists").child(code)
        performSegue(withIdentifier: "toPlaylist", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let currentVC = segue.destination as? CurrentPlaylistViewController {
            currentVC.code = code
            currentVC.playlist = playlist
            currentVC.songs = playlist.songs
            currentVC.user = !self.guest
        }
    }
}

