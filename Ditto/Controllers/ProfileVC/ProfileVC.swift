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
import Alamofire

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
    
    let currentID = UserDefaults.standard.value(forKey: "id")! as! String
    

    var playlistTitleList : [String] = []
    var playlistLastPlayed : [String] = ["last played: 6h"]
    
    var onames : [String] = []
    var mnames : [String] = []
    var ocodes : [String] = []
    var mcodes : [String] = []
    var oimages : [UIImage] = []
    var mimages : [UIImage] = []
    var playlistImageList : [UIImage] = []
    
    var playlist : Playlist!
    let url = "https://api.spotify.com/v1/tracks/"
    let parameters: HTTPHeaders = ["Accept":"application/json", "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "accessToken")!)"]
    typealias JSONStandard = [String : AnyObject]

    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInformation()
        initUI()
        setUpImagePicker()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUserInformation()
        getPlaylists()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customSC.selectedSegmentIndex = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        customSC.selectedSegmentIndex = 0
    }
    
    func getUserInformation() {
        print(currentID)
        print("just tried to print current id")
        let db = Database.database().reference()
        let userNode = db.child("users")
        
        userNode.child(currentID).observe(.value, with: { (snapshot) in
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
                self.nameLabel.text = retrievedName
                self.getPlaylists()
            } else {
                print(self.currentID)
                print(snapshot)
                print("why is going here")
            }
        })
    }
    
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
        playlistImageList = []
        switch customSC.selectedSegmentIndex {
        case 0 :
            playlistTitleList = onames
            playlistLastPlayed = ocodes
            playlistImageList = oimages
            self.tableView.reloadData()
        case 1:
            playlistTitleList = mnames
            playlistLastPlayed = mcodes
            playlistImageList = mimages
            self.tableView.reloadData()
        default: break
        }
    }
}
