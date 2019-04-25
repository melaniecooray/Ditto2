//
//  ProfileVC.swift
//  Ditto
//
//  Created by Melanie Cooray on 3/16/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class ProfileViewController: UIViewController {
    
    var backgroundImage: UIImageView!
    
    var signOutButton: UIButton!
    
    var profilePic: UIImageView!
    
    var nameLabel: UILabel!
    var retrievedName = ""
    
    var customSC: UISegmentedControl!
    var tableView: UITableView!
    
    var imageView: UIImageView!
    var imagePicker: UIButton!
    
    var chosenImage: UIImage!
    
    //var playlists: [String] = ["vibe station", "spring 2019 jams", "bucket list: songs we must listen to", "econ 100a ~lit~ study group"]
    //var played: [String] = ["17h", "2d", "6h", "8d"]
    var playlistTitleList : [String] = []
    //var playlistTitleList : [String] = ["bucket list: songs we must listen to", "vibe station", "spring 2019 jams", "econ100a ~lit~ study group", "triple bffl favorites"]
    var playlistLastPlayed : [String] = ["last played: 6h"]
    //var playlistLastPlayed : [String] = ["last played: 6h", "last played: 17h", "last played: 17h", "last played: 2d", "last played: 8d", "last played: 9d"]
    var onames : [String] = []
    var mnames : [String] = []
    var ocodes : [String] = []
    var mcodes : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInformation()
        initUI()
        setUpImagePicker()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUserInformation()
        self.tableView.reloadData()
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
                if let names = value?["owned playlist names"] as? [String] {
                    self.playlistTitleList = names
                    self.onames = names
                    self.ocodes = value?["owned playlist codes"] as! [String]
                    self.playlistLastPlayed = self.ocodes
                }
                if let mnames = value?["member playlist names"] as? [String] {
                    self.mnames = mnames
                    self.mcodes = value?["member playlist codes"] as! [String]
                }
                print("fullnameretrieved")
                print(retrievedName)
                self.tableView.reloadData()
                self.nameLabel.text = retrievedName
            } else {
                print(currentID)
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
    
    @objc func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            let alertController = UIAlertController(title: "Error Logging Out", message:
                signOutError.debugDescription, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        performSegue(withIdentifier: "signOut", sender: nil)
    }
    
    @objc func indexChanged(_ sender: Any) {
        switch customSC.selectedSegmentIndex {
        case 0 :
            playlistTitleList = onames
            playlistLastPlayed = ocodes
            self.tableView.reloadData()
        case 1:
            playlistTitleList = mnames
            playlistLastPlayed = mcodes
            self.tableView.reloadData()
        default: break
        }
    }
}
