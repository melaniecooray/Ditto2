//
//  ProfileVC.swift
//  Ditto
//
//  Created by Melanie Cooray on 3/16/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    var signOutButton: UIButton!
    
    var profilePic: UIImageView!
    
    var nameLabel: UILabel!
    var retrievedName = ""
    
    var customSC: UISegmentedControl!
    var tableView: UITableView!
    
    var playlists: [String] = ["vibe station", "spring 2019 jams", "bucket list: songs we must listen to", "econ 100a ~lit~ study group"]
    var played: [String] = ["17h", "2d", "6h", "8d"]
    var playlistTitleList : [String] = ["bucket list: songs we must listen to", "vibe station", "spring 2019 jams", "econ100a ~lit~ study group", "triple bffl favorites"]
    var playlistLastPlayed : [String] = ["last played: 6h", "last played: 17h", "last played: 17h", "last played: 2d", "last played: 8d", "last played: 9d"]

    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInformation()
        initUI()
        
    }
    func getUserInformation() {
        let currentID = UserDefaults.standard.value(forKey: "id")!
        print(currentID)
        print("just tried to print current id")
        let db = Database.database().reference()
        let userNode = db.child("users")
        
        userNode.child(currentID as! String).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                
                let value = snapshot.value as? NSDictionary
                let retrievedName = value?["Name"] as? String
                print("fullnameretrieved")
                print(retrievedName)
                self.nameLabel.text = retrievedName
            } else {
                print(snapshot)
                print("why is going here")
            }
        })
    }
//    //added
//    let ref = Database.database().reference(withPath: "user")
//    ref.observeSingleEvent(of: .value, with: { snapshot in
//
//    if !snapshot.exists() { return }
//
//    print(snapshot) // Its print all values including Snap (User)
//
//    print(snapshot.value!)
//
//    let username = snapshot.childSnapshot(forPath: "full_name").value
//    print(username!)
//
//    })
//
//    //added
//
//    func userInformation() {
//
//        let currentID = UserDefaults.standard.value(forKey: "id")!
//        let db = Database.database().reference()
//
//
//}
}
