//
//  EditPlaylistViewController.swift
//  Ditto
//
//  Created by Sam Lee on 4/20/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EditPlaylistViewController: UIViewController {
    
    var backgroundImage: UIImageView!
    var tableView: UITableView!
    
    var playlist: Playlist!
    
    var songs : [Song] = []
    var songList : [String] = []
    var playlistSongs : [String] = []
    
    var name: String!
    var artist: String!
//    var playlistSongs: [edit]
//    var currentSong : String!
//    var currentIndex = 0

    
    var recentlyPlayedLabel: UILabel!
    
    var songTitleList : [String] = []
//        = ["Song Title1", "Song Title2", "Song Title3", "Song Title4", "Song Title5"]
    var songArtistList : [String]! = []
//        = ["Artist Name1", "Artist Name2", "Artist Name3", "Artist Name4", "Artist Name5", "Artist Name6"]
    var filteredArray : [String] = []
    
    lazy var mainSearchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    var isSearching = false
    
    var addButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPlaylistSongs()
        setUpBackground()
        //setUpSearchBar()
        //setUpTable()
        //setUpLabel()
        //setUpAddButton()
        
        
        mainSearchBar.delegate = self
        mainSearchBar.returnKeyType = UIReturnKeyType.done
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func addButtonClicked() {
        //performSegue(withIdentifier: "toNewPlaylist", sender: self)
        self.tabBarController?.selectedIndex = 1
        let navController = self.tabBarController?.viewControllers![1] as! UINavigationController
        let resultVC = CreateNewPlaylistTableViewController()
        //        resultVC.code = UserDefaults.standard.value(forKey: "code") as! String
        //        resultVC.playlist = Playlist(id: playlistID!, playlist: ["name": name, "code": UserDefaults.standard.value(forKey: "code"), "songs": selectedSongs])
        UserDefaults.standard.set("update", forKey: "playlistStatus")
        navController.pushViewController(resultVC, animated: true)
    }
    
    func getPlaylistSongs() {
        let db = Database.database().reference()
        let playlistNode = db.child("playlists")
        playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let dict = snapshot.value as! [String : Any]
            let songs = dict["songs"] as! [String]
            self.songList = songs
            
            for song in self.songs {
                self.songTitleList.append(song.name)
                self.songArtistList.append(song.artist)
                }
            
//            self.currentSong = songs[self.currentIndex]
            print(self.songTitleList)
            print(self.songArtistList)
            self.setUpSearchBar()
            self.setUpTable()
            self.setUpLabel()
            self.setUpAddButton()
            }
        )}
    }

