//
//  EditPlaylistViewController.swift
//  Ditto
//
//  Created by Sam Lee on 4/20/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EditPlaylistViewController: UIViewController, UISearchBarDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate {
    
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
    var lengths : [Int] = []
    
    lazy var mainSearchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    var isSearching = false
    
    var addButton: UIButton!
    
    var player : SPTAudioStreamingController?
    var pause : Bool!
    
    var first = true
    var owner = true
    var guest = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackground()
        getPlaylistSongs()
        setUpBackground()
        addTapDismiss()
        
        self.navigationController?.delegate = self
        
        self.mainSearchBar.delegate = self
        self.tabBarController?.delegate = self
        self.mainSearchBar.returnKeyType = UIReturnKeyType.done
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mainSearchBar.delegate = self
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //print("entered")
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    func addTapDismiss() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    @objc func dismissKeyboard() {
        mainSearchBar.resignFirstResponder()
    }
    
    @objc func addButtonClicked() {
        //performSegue(withIdentifier: "toNewPlaylist", sender: self)
        //print("going to add song")
        self.tabBarController?.selectedIndex = 1
        let navController = self.tabBarController?.viewControllers![1] as! UINavigationController
        let resultVC = CreateNewPlaylistTableViewController()
        //        resultVC.code = UserDefaults.standard.value(forKey: "code") as! String
        //        resultVC.playlist = Playlist(id: playlistID!, playlist: ["name": name, "code": UserDefaults.standard.value(forKey: "code"), "songs": selectedSongs])
        resultVC.previousSongs = songs
        resultVC.owner = self.owner
        resultVC.guest = self.guest
        UserDefaults.standard.set("update", forKey: "playlistStatus")
        navController.pushViewController(resultVC, animated: true)
    }
    
    func getPlaylistSongs() {
        let db = Database.database().reference()
        let playlistNode = db.child("playlists")
        playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).observe(.value, with: { (snapshot) in
            
            let dict = snapshot.value as! [String : Any]
            let songs = dict["songs"] as! [String]
            self.songList = songs
            self.lengths = dict["lengths"] as! [Int]
            
            self.songTitleList = []
            self.songArtistList = []
            
            for song in self.songs {
                self.songTitleList.append(song.name)
                self.songArtistList.append(song.artist)
            }
            
            if let list = dict["artists"] as? [String] {
                self.songArtistList = list
            }
            if let list2 = dict["names"] as? [String] {
                self.songTitleList = list2
            }
            
//            self.currentSong = songs[self.currentIndex]
            //print(self.songTitleList)
            //print(self.songArtistList)
            if self.first {
                self.first = false
                self.setUpSearchBar()
                self.setUpTable()
                self.setUpLabel()
                self.mainSearchBar.delegate = self
            } else {
                self.tableView.reloadData()
            }
            //self.setUpAddButton()
            }
        )}
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search clicked")
        if mainSearchBar.text == nil || mainSearchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
            mainSearchBar.resignFirstResponder()
        } else {
            isSearching = true
            filteredArray = songTitleList.filter({$0.range(of: mainSearchBar.text!, options: .caseInsensitive) != nil})
            tableView.reloadData()
            print("seachworkedhere2")
            mainSearchBar.resignFirstResponder()
            
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searching")
        print(mainSearchBar.text)
        print(searchText)
        if mainSearchBar.text == nil || mainSearchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filteredArray = songTitleList.filter({$0.range(of: mainSearchBar.text!, options: .caseInsensitive) != nil})
            tableView.reloadData()
            print("seachworkedhere2")
        }
    }
    
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        (viewController as? CurrentPlaylistViewController)?.pause = self.pause
        (viewController as? CurrentPlaylistViewController)?.owner = self.owner
    }
    
}



