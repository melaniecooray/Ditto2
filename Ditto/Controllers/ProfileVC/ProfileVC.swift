//
//  ProfileVC.swift
//  Ditto
//
//  Created by Melanie Cooray on 3/16/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var signOutButton: UIButton!
    
    var profilePic: UIImageView!
    
    var nameLabel: UILabel!
    
    var customSC: UISegmentedControl!
    var tableView: UITableView!
    
    var playlists: [String] = ["vibe station", "spring 2019 jams", "bucket list: songs we must listen to", "econ 100a ~lit~ study group"]
    var played: [String] = ["17h", "2d", "6h", "8d"]
    var playlistTitleList : [String] = ["bucket list: songs we must listen to", "vibe station", "spring 2019 jams", "econ100a ~lit~ study group", "triple bffl favorites"]
    var playlistLastPlayed : [String] = ["last played: 6h", "last played: 17h", "last played: 17h", "last played: 2d", "last played: 8d", "last played: 9d"]

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        
    }
    
}
