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
import FirebaseStorage
import Alamofire

class PlaylistsViewController: UIViewController {
    
    var backgroundImage: UIImageView!
    var tableView: UITableView!
    
    var recentlyPlayedLabel: UILabel!
    
    var playlistTitleList : [String] = []
    var playlistCodeList : [String : String] = [:]
    var playlistImageList : [String : UIImage] = [:]
    var playlistLastPlayed : [String] = ["last played: 6h", "last played: 17h", "last played: 17h", "last played: 2d", "last played: 8d", "last played: 9d"]
    var filteredArray : [String] = []
    
    lazy var mainSearchBar: UISearchBar = {
       let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    var isSearching = false
    
    var addButton: UIButton!
    var emptyLabel : UILabel!
    var loadingIcon : UIActivityIndicatorView!
    
    var playlist : Playlist!
    let url = "https://api.spotify.com/v1/tracks/"
    let parameters: HTTPHeaders = ["Accept":"application/json", "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "accessToken")!)"]
    typealias JSONStandard = [String : AnyObject]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackground()
        setUpTable()
        setUpLabel()
        setUpAddButton()
        addTapDismiss()
        
        mainSearchBar.delegate = self
        mainSearchBar.returnKeyType = UIReturnKeyType.done
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUserInformation()
        self.tableView.reloadData()
        addTapDismiss()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        loadingIcon = UIActivityIndicatorView(style: .whiteLarge)
        loadingIcon.frame = self.view.frame
        loadingIcon.center = self.view.center
        view.addSubview(loadingIcon)
        addButton.isEnabled = true
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
        let db = Database.database().reference()
        let userNode = db.child("users")
        
        userNode.child(currentID as! String).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                
                let value = snapshot.value as? NSDictionary
                let retrievedName = value?["Name"] as? String
                if let names = value?["owned playlist names"] as? [String] {
                    self.playlistTitleList = names
                }
                //print(value?["member playlist names"] as? [String])
                if let mnames = value?["member playlist names"] as? [String] {
                    //print(value?["member playlist names"] as? [String])
                    self.playlistTitleList.append(contentsOf: mnames)
                }
                var index = 0
                if let ocodes = value?["owned playlist codes"] as? [String] {
                    for code in ocodes {
                        self.playlistCodeList.updateValue(code, forKey: self.playlistTitleList[index])
                        index += 1
                    }
                }
                if let mcodes = value?["member playlist codes"] as? [String] {
                    for code in mcodes {
                        self.playlistCodeList.updateValue(code, forKey: self.playlistTitleList[index])
                        index += 1
                    }
                }
                if self.playlistCodeList.isEmpty {
                    self.recentlyPlayedLabel.text = "No joined playlists"
                } else {
                    self.playlistTitleList = self.playlistTitleList.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
                    self.tableView.reloadData()
                    self.getPlaylists()
                }
            } else {
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


