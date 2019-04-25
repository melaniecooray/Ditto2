//
//  EditPlaylistViewController.swift
//  Ditto
//
//  Created by Sam Lee on 4/20/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit

class EditPlaylistViewController: UIViewController {
    
    var backgroundImage: UIImageView!
    var tableView: UITableView!
    
    var recentlyPlayedLabel: UILabel!
    
    var songTitleList : [String] = ["Song Title1", "Song Title2", "Song Title3", "Song Title4", "Song Title5"]
    var songArtistList : [String] = ["Artist Name1", "Artist Name2", "Artist Name3", "Artist Name4", "Artist Name5", "Artist Name6"]
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
    
        setUpBackground()
        setUpSearchBar()
        setUpTable()
        setUpLabel()
        setUpAddButton()
        
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
        navController.pushViewController(resultVC, animated: true)
    }


    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
