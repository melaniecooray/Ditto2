//
//  PlaylistsVC.swift
//  Ditto
//
//  Created by Melanie Cooray on 3/16/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit

class PlaylistsViewController: UIViewController {
    
    var backgroundImage: UIImageView!
    var tableView: UITableView!
    
    var recentlyPlayedLabel: UILabel!
    
    var playlistTitleList : [String] = ["bucket list: songs we must listen to", "vibe station", "spring 2019 jams", "econ100a ~lit~ study group", "triple bffl favorites"]
    var playlistLastPlayed : [String] = ["last played: 6h", "last played: 17h", "last played: 17h", "last played: 2d", "last played: 8d", "last played: 9d"]
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
        

        setUpSearchBar()
        setUpBackground()
        setUpTable()
        setUpLabel()
        setUpAddButton()
        
        mainSearchBar.delegate = self
        mainSearchBar.returnKeyType = UIReturnKeyType.done
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func addButtonClicked() {
        performSegue(withIdentifier: "toNewPlaylist", sender: self)
    }
    
    
    
}


