//
//  EditPlaylistViewController.swift
//  Ditto
//
//  Created by Sam Lee on 4/20/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EditPlaylistViewController: UIViewController, UISearchBarDelegate, UINavigationControllerDelegate {
    
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
    
    var player : SPTAudioStreamingController?
    var pause : Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPlaylistSongs()
        setUpBackground()
        addTapDismiss()
        //setUpSearchBar()
        //setUpTable()
        //setUpLabel()
        //setUpAddButton()
        
        self.navigationController?.delegate = self
        
        self.mainSearchBar.delegate = self
        self.mainSearchBar.returnKeyType = UIReturnKeyType.done
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
    }
    
    func addTapDismiss() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    @objc func dismissKeyboard() {
        mainSearchBar.resignFirstResponder()
    }
    
    @objc func addButtonClicked() {
        //performSegue(withIdentifier: "toNewPlaylist", sender: self)
        print("going to add song")
        self.tabBarController?.selectedIndex = 1
        let navController = self.tabBarController?.viewControllers![1] as! UINavigationController
        let resultVC = CreateNewPlaylistTableViewController()
        //        resultVC.code = UserDefaults.standard.value(forKey: "code") as! String
        //        resultVC.playlist = Playlist(id: playlistID!, playlist: ["name": name, "code": UserDefaults.standard.value(forKey: "code"), "songs": selectedSongs])
        //resultVC.previousSongs = songs
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
            //self.setUpAddButton()
            }
        )}
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if mainSearchBar.text == nil || mainSearchBar.text == "" {
            print("searching")
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filteredArray = songTitleList.filter({$0.range(of: mainSearchBar.text!, options: .caseInsensitive) != nil})
            tableView.reloadData()
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        (viewController as? CurrentPlaylistViewController)?.pause = self.pause
    }
    
}


