//
//  LoginVC.swift
//  Ditto
//
//  Created by Melanie Cooray on 3/16/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import FirebaseAuth
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var scrollView: UIScrollView!
    
    var code: UITextField!
    var joinButton: UIButton!
    
    var logo: UIImageView!
    
    var emailTextField : SkyFloatingLabelTextField!
    var passwordTextField : SkyFloatingLabelTextField!
    
    var loginButton: UIButton!
    
    var signUpText: UILabel!
    var signUpButton: UIButton!
    
    var player : SPTAudioStreamingController?
    
    var playlist : Playlist!
    let url = "https://api.spotify.com/v1/tracks/"
    let parameters: HTTPHeaders = ["Accept":"application/json", "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "accessToken")!)"]
    typealias JSONStandard = [String : AnyObject]

    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                print("logged in")
                self.alreadySignedIn()
            } else {
                self.initUI()
                self.addTapDismiss()
            }
        }
//        if Auth.auth().currentUser != nil {
//            UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "id")
//            print("logged in")
//            self.alreadySignedIn()
//        }
        
        //initUI()
        addTapDismiss()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func addTapDismiss() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    @objc func dismissKeyboard() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        code.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                if !code.isEditing {
                    self.view.frame.origin.y -= 200
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func login() {
        var userUsername: String?
        var userPassword: String?
        
        if let usern = emailTextField.text {
            userUsername = usern
        }
        
        if let pass = passwordTextField.text {
            userPassword = pass
        }
        
        if emailTextField.text == "" {
            self.loginButton.isUserInteractionEnabled = true
            showError(title: "Information Missing", message: "No Username Entered")
            return
        }
        
        if passwordTextField.text == "" {
            self.loginButton.isUserInteractionEnabled = true
            showError(title: "Information Missing", message: "No Password Entered")
            return
        }
        
        loginButton.isEnabled = false
        loginButton.backgroundColor = .gray
        loginButton.setTitle("Loading...", for: .normal)
        
        Auth.auth().signIn(withEmail: userUsername!, password: userPassword!, completion: { (user, error) in
            if let error = error {
                self.loginButton.isUserInteractionEnabled = true
                self.loginButton.isEnabled = true
                self.loginButton.backgroundColor = UIColor(hexString: "7383C5")
                self.loginButton.setTitle("Login", for: .normal)
                print(error)
                self.showError(title: "Error:", message: "Could not sign in user.")
                return
            } else {
                self.performSegue(withIdentifier: "loggedIn", sender: self)
            }
        })
    }
    
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func alreadySignedIn() {
        print("performing segue")
        performSegue(withIdentifier: "loggedIn", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let resultVC = segue.destination as? TabBarController {
            
        }
        if let previewVC = segue.destination as? PreviewPlaylistViewController {
            previewVC.code = code.text!
            previewVC.playlist = playlist
        }
    }
    
    @objc func checkCode() {
        let codeEntered = code.text
        if codeEntered == "" {
            showError(title: "Invalid", message: "Please enter in a playlist code.")
            return
        } else if codeEntered!.count != 6 {
            showError(title: "Invalid", message: "A playlist code is 6 characters.")
            return
        } else if codeEntered!.contains(" ") {
            showError(title: "Invalid", message: "A playlist code cannot have spaces.")
        }
        let db = Database.database().reference()
        let playlistNode = db.child("playlists")
        let userNode = db.child("users")
        
        playlistNode.child(codeEntered!).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                UserDefaults.standard.set(codeEntered, forKey: "code")
                print("code worked")
                let dict = snapshot.value as! [String : Any]
                var owner = dict["owner"] as! String
                var previousMembers = dict["members"] as! [String]
                self.makePlaylist(dict: dict, previousMembers: previousMembers)
            } else {
                print("error with " + self.code.text!)
                print(snapshot)
                self.showError(title: "Error", message: "A playlist with that code does not exist.")
            }
        })
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
            self.playlist = Playlist(id: id, playlist: ["code": self.code.text, "members": previousMembers, "name": name, "songs": songs, "owner": owner])
            self.performSegue(withIdentifier: "joinedCode", sender: self)
        })
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if code.isFirstResponder == true {
            code.placeholder = ""
        }
    }

}
