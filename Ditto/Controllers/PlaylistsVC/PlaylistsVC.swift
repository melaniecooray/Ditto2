//
//  PlaylistsVC.swift
//  Ditto
//
//  Created by Melanie Cooray on 3/16/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class PlaylistsViewController: UIViewController {
    
    var backgroundImage: UIImageView!
    var tableView: UITableView!
    
    var recentlyPlayedLabel: UILabel!
    
    var playlistTitleList : [String] = []
    var playlistCodeList : [String : String] = [:]
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
        getUserInformation()
        addTapDismiss()
        
        mainSearchBar.delegate = self
        mainSearchBar.returnKeyType = UIReturnKeyType.done
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func addButtonClicked() {
        performSegue(withIdentifier: "toNewPlaylist", sender: self)
    }
    
    func getUserInformation() {
        UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "id")
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
                    self.playlistTitleList.append(contentsOf: names)
                }
                if let mnames = value?["member playlist names"] as? [String] {
                    self.playlistTitleList.append(contentsOf: mnames)
                }
                if let ocodes = value?["owned playlist codes"] as? [String] {
                    var index = 0
                    for code in ocodes {
                        self.playlistCodeList.updateValue(code, forKey: self.playlistTitleList[index])
                    }
                }
                if let mcodes = value?["member playlist codes"] as? [String] {
                    var index = 0
                    for code in mcodes {
                        self.playlistCodeList.updateValue(code, forKey: self.playlistTitleList[index])
                    }
                }
                print("fullnameretrieved")
                print(retrievedName)
                self.tableView.reloadData()
                //self.nameLabel.text = retrievedName
            } else {
                print(currentID)
                print(snapshot)
                print("why is going here")
            }
        })
    }
    
    func addTapDismiss() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    @objc func dismissKeyboard() {
        mainSearchBar.resignFirstResponder()
    }
    
    
    
}


