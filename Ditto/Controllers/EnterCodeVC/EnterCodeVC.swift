//
//  EnterCodeVC.swift
//  Ditto
//
//  Created by Candace Chiang on 4/6/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class EnterCodeViewController: UIViewController, UITextFieldDelegate {
    
    var backgroundImage: UIImageView!
    var tagLabel: UILabel!
    var codeInput: UITextField!
    var searchButton: UIButton!
    
    var code = ""
    var playlist : Playlist!
    
    var getUserURL = "https://api.spotify.com/v1/me"
    let parameters: HTTPHeaders = ["Accept":"application/json", "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "accessToken")!)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackground()
        setUpLabels()
        setUpInteractive()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.codeInput.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //dismiss keyboard when you press return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func codeEntered(_ sender: UITextField) {
        let possCode = sender.text
        if possCode != "" {
            code = possCode!.uppercased()
        }
    }
    
    @objc func filter(_ sender: UIButton) {
        //actually filter here?
        if code == "" {
            showError(title: "Invalid", message: "Please enter in a playlist code.")
            return
        } else if code.count != 6 {
            showError(title: "Invalid", message: "A playlist code is 6 characters.")
            return
        } else if code.contains(" ") {
            showError(title: "Invalid", message: "A playlist code cannot have spaces.")
        }
        let db = Database.database().reference()
        let playlistNode = db.child("playlists")
        
        playlistNode.child(self.code).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                UserDefaults.standard.set(self.code, forKey: "code")
                print("code worked")
                let dict = snapshot.value as! [String : Any]
                var previousMembers = dict["members"] as! [String]
                if previousMembers.contains(Auth.auth().currentUser!.uid) {
                    self.showError(title: "Error:", message: "You are already part of this playlist")
                    return
                }
                previousMembers.append(UserDefaults.standard.value(forKey: "id") as! String)
                playlistNode.child(self.code).updateChildValues(["members" : previousMembers])
                let owner = dict["owner"] as! String
                let songs = dict["songs"] as! [String]
                let name = dict["name"] as! String
                let id = dict["id"] as! String
                self.playlist = Playlist(id: id, playlist: ["code": self.code, "members": previousMembers, "name": name, "songs": songs, "owner": owner])
                /*
                AF.request(getUserURL, headers: parameters).responseJSON(completionHandler: {
                    response in
                    do {
                        print("Success!!!!")
                        var readableJSON = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! JSONStandard
                        if let user_id = readableJSON["id"] {
                            print(user_id)
                            UserDefaults.standard.set(user_id, forKey: "user_id")
                            self.userID = user_id as? String
                            print(UserDefaults.standard.value(forKey: "id")!)
                            playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).updateChildValues(["songs": self.songuris, "members" : [UserDefaults.standard.value(forKey: "id")], "owner" : UserDefaults.standard.value(forKey: "id")])
                            self.playlists.append(UserDefaults.standard.value(forKey: "code") as! String)
                            self.names.append(self.name)
                            userNode.child(UserDefaults.standard.value(forKey: "id") as! String).updateChildValues(["owned playlist codes" : self.playlists, "owned playlist names" : self.names])
                            let createPlaylistURL = "https://api.spotify.com/v1/users/\(user_id)/playlists"
                            print(self.userID)
                        }}})
 */
                self.performSegue(withIdentifier: "toPreview", sender: self)
            } else {
                print("error with " + self.code)
                print(snapshot)
                self.showError(title: "Error", message: "A playlist with that code does not exist.")
            }
        })
        
        //        playlistNode.observeSingleEvent(of: .value, with: { (snapshot) in
        //            for playlist in snapshot.children {
        //                let newPlaylist = playlist as! DataSnapshot
        //                let dict = newPlaylist.value as! [String : Any]
        //                let codeCheck = dict["code"] as! String
        //                print(self.code)
        //                print(dict["code"]!)
        //                if (self.code == codeCheck) {
        //                    UserDefaults.standard.set(self.code, forKey: "code")
        //                    print("code worked")
        //                    self.performSegue(withIdentifier: "toPreview", sender: self)
        //                } else {
        //                    self.showError(title: "Error", message: "A playlist with that code does not exist.")
        //                }
        //            }
        //        })
        //performSegue(withIdentifier: "toPreview", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let previewVC = segue.destination as! PreviewPlaylistViewController
        previewVC.code = code
        previewVC.playlist = playlist
    }
    
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
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



