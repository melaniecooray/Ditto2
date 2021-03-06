//
//  EnterCodeVC.swift
//  Ditto
//
//  Created by Candace Chiang on 4/6/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import Alamofire

class EnterCodeViewController: UIViewController, UITextFieldDelegate {
    
    var backgroundImage: UIImageView!
    var tagLabel: UILabel!
    var codeInput: UITextField!
    var searchButton: UIButton!
    
    var code = ""
    var playlist : Playlist!
    var songs : [Song] = []
    var segue = false
    var loadingView : UIView!
    var loadingIcon : UIActivityIndicatorView!
    
    var getUserURL = "https://api.spotify.com/v1/me"
    let parameters: HTTPHeaders = ["Accept":"application/json", "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "accessToken")!)"]
    let url = "https://api.spotify.com/v1/tracks/"
    typealias JSONStandard = [String : AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackground()
        setUpLabels()
        setUpInteractive()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if segue {
            loadingView = UIView(frame: self.view.frame)
            loadingView.backgroundColor = .white
            loadingIcon = UIActivityIndicatorView(style: .whiteLarge)
            let resultVC = CurrentPlaylistViewController()
            resultVC.code = code
            resultVC.playlist = playlist
            resultVC.songs = songs
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
        self.codeInput.delegate = self
        searchButton.isEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchButton.isEnabled = true
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
            searchButton.isEnabled = true
            return
        } else if code.count != 6 {
            showError(title: "Invalid", message: "A playlist code is 6 characters.")
            searchButton.isEnabled = true
            return
        } else if code.contains(" ") {
            showError(title: "Invalid", message: "A playlist code cannot have spaces.")
            searchButton.isEnabled = true
        } else {
            let db = Database.database().reference()
            let playlistNode = db.child("playlists")
            let userNode = db.child("users")
            
            playlistNode.child(self.code).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    UserDefaults.standard.set(self.code, forKey: "code")
                    print("code worked")
                    let dict = snapshot.value as! [String : Any]
                    var owner = dict["owner"] as! String
                    var previousMembers = dict["members"] as! [String]
                    if owner != Auth.auth().currentUser!.uid {
                        if !previousMembers.contains(Auth.auth().currentUser!.uid) {
                            previousMembers.append(UserDefaults.standard.value(forKey: "id") as! String)
                            playlistNode.child(self.code).updateChildValues(["members" : previousMembers])
                        }
                        userNode.child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                            let dict2 = snapshot.value as! [String : Any]
                            var currentMemPlaylistCodes : [String] = []
                            var currentMemPlaylistNames : [String] = []
                            if let codes = dict2["member playlist codes"] as? [String] {
                                currentMemPlaylistCodes = codes
                                currentMemPlaylistNames = dict2["member playlist names"] as! [String]
                            }
                            if !currentMemPlaylistCodes.contains(dict["code"] as! String) {
                                currentMemPlaylistCodes.append(dict["code"] as! String)
                                currentMemPlaylistNames.append(dict["name"] as! String)
                                userNode.child(Auth.auth().currentUser!.uid).updateChildValues(["member playlist codes" : currentMemPlaylistCodes, "member playlist names" : currentMemPlaylistNames])
                            }
                        })
                    }
                    self.makePlaylist(dict: dict, previousMembers: previousMembers)
                    self.searchButton.isEnabled = false
                } else {
                    print("error with " + self.code)
                    print(snapshot)
                    self.showError(title: "Error", message: "A playlist with that code does not exist.")
                }
            })
        }
    }
    
    func makePlaylist(dict: [String: Any], previousMembers: [String]) {
        let owner = dict["owner"] as! String
        let name = dict["name"] as! String
        let id = dict["uri"] as! String
        let songuris = dict["songs"] as! [String]
        var songs: [Song] = []
        for songuri in songuris {
            songs.append(Song(id: songuri))
        }
        
        let dispatchGroup = DispatchGroup()
        for (index, songuri) in songuris.enumerated() {
            dispatchGroup.enter()
            let indexString = songuri.index(songuri.startIndex, offsetBy: 14)
            let trackID = String(songuri[indexString...])
            AF.request(url + trackID, headers: parameters).responseJSON(completionHandler: {
                response in
                do {
                    var track = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! JSONStandard
                    print(songuri)
                    print(trackID)
                    print(track)
                    var artistString = ""
                    if let artists = track["artists"] as? [JSONStandard] {
                    
                        for artist in artists {
                            let artistName = artist["name"] as! String
                            artistString += artistName + ", "
                        }
                    
                        artistString = String(artistString.dropLast(2))
                    }
                    songs[index].artist = artistString
                    songs[index].name = track["name"] as! String
                
                    if let album = track["album"] as? JSONStandard {
                        if let images = album["images"] as? [JSONStandard] {
                            let imageData = images[0]
                            let mainImageURL = URL(string: imageData["url"] as! String)
                            let mainImageData = NSData(contentsOf: mainImageURL!)
                            let mainImage = UIImage(data: mainImageData as! Data)
                            songs[index].image = mainImage
                            
                            dispatchGroup.leave()
                        }
                    }
                } catch {
                    print(error)
                }
            })
        }
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            print(songs)
            self.playlist = Playlist(id: id, playlist: ["code": self.code, "members": previousMembers, "name": name, "songs": songs, "owner": owner])
            self.performSegue(withIdentifier: "toPreview", sender: self)
        })
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



