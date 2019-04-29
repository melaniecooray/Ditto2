//
//  CreateNewPlaylistViewController.swift
//  Ditto
//
//  Created by Sam Lee on 4/11/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseDatabase
import SwiftyJSON

struct post {
    let mainImage : UIImage!
    let name : String!
    let artist: String!
    let length: Int!
    var checked: Bool!
}

class CreateNewPlaylistTableViewController: UIViewController, UISearchBarDelegate {

    //@IBOutlet var searchBar: UISearchBar!
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    var backgroundImage: UIImageView!
    var tableView: UITableView!
    var loadingLabel : UILabel!
    var loadingIcon : UIActivityIndicatorView!
    
    var name : String!
    var userID: String!
    var playlistID: String!
    var posts = [post]()
    var temp: [Song] = []
    var previousSongs : [Song] = []
    var selectedSongs: [Song] = []
    var imageList: [UIImage] = []
    var uris : [String] = []
    var playlists : [String] = []
    var songuris : [String] = []
    var names : [String] = []
    var lengths : [Int] = []
    var nameList : [String] = []
    var artistList : [String] = []
    var new = true
    var owner = true
    var playlistOwner : String!
    var guest = false
    
    var searchURL = String()
    var getUserURL = "https://api.spotify.com/v1/me"
    let parameters: HTTPHeaders = ["Accept":"application/json", "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "accessToken")!)"]
    typealias JSONStandard = [String : AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pickedSongs))
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        if (UserDefaults.standard.value(forKey: "playlistStatus") as! String == "update") {
            new = false
        }
        setUpBackground()
        setUpSearchBar()
        setUpTable()
        searchBar.delegate = self
    }
    

    override func viewDidAppear(_ animated: Bool) {
        loadingIcon = UIActivityIndicatorView(style: .whiteLarge)
        loadingIcon.frame = self.view.frame
        loadingIcon.center = self.view.center
        view.addSubview(loadingIcon)
    }

    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        loadingIcon.startAnimating()
        let keywords = searchBar.text
        let finalKeywords = keywords?.replacingOccurrences(of: " ", with: "+")
        searchURL  = "https://api.spotify.com/v1/search?q=\(finalKeywords!)&type=track"
        posts.removeAll()
        uris.removeAll()
        for song in temp {
            selectedSongs.append(song)
        }
        temp.removeAll()
        
        callAlamo(url: searchURL, headers: parameters)
        self.view.endEditing(true)
    }
    
    func callAlamo(url : String, headers: HTTPHeaders){
        AF.request(url, headers: parameters).responseJSON(completionHandler: {
            response in
            
            self.parseData(JSONData: response.data!)
        })
    }
    
    func parseData(JSONData : Data) {
        setupLoadingLabel()
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            
            if let tracks = readableJSON["tracks"] as? JSONStandard{
                if let items = tracks["items"] as? [JSONStandard]{
                    
                    for i in 0..<items.count {
                        
                        let item = items[i]
                        
                        let name = item["name"] as! String
                        let uri = item["uri"] as! String
                        let artists = item["artists"] as! [JSONStandard]
                        var length = item["duration_ms"] as! Int
                        length = length / 1000
                        var artistString = ""
                        
                        for artist in artists {
                            let artistName = artist["name"] as! String
                            artistString += artistName + ", "
                        }
                        
                        artistString = String(artistString.dropLast(2))

                        
                        if let album = item["album"] as? JSONStandard {
                            if let images = album["images"] as? [JSONStandard] {
                                let imageData = images[0]
                                let mainImageURL = URL(string: imageData["url"] as! String)
                                let mainImageData = NSData(contentsOf: mainImageURL!)
                                
                                let mainImage = UIImage(data: mainImageData as! Data)
                                

                                posts.append(post.init(mainImage: mainImage, name: name, artist: artistString, length: length, checked: false))
                                uris.append(uri)
                                self.loadingLabel.removeFromSuperview()
                                self.tableView.reloadData()
                                loadingIcon.stopAnimating()
                                resetAccessoryType()
                            }
                        }
                    }
                }
            }

        }catch{
            print(error)
        }
    }
    
    @objc func pickedSongs() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        loadingIcon.startAnimating()
        for song in temp {
            selectedSongs.append(song)
        }
        for song in selectedSongs {
            songuris.append(song.id)
            lengths.append(song.length)
            nameList.append(song.name)
            artistList.append(song.artist)
        }
        
        let db = Database.database().reference()
        let playlistNode = db.child("playlists")
        let userNode = db.child("users")
        
        if new {
            userNode.child(UserDefaults.standard.value(forKey: "id") as! String).observeSingleEvent(of: .value, with: {
                snapshot in
                let dict = snapshot.value as! [String : Any]
                if let lists = dict["owned playlist codes"] as? [String] {
                    self.playlists = lists
                }
                if let names = dict["owned playlist names"] as? [String] {
                    self.names = names
                }
            })
        }
        
        AF.request(getUserURL, headers: parameters).responseJSON(completionHandler: {
            response in
            do {
                var readableJSON = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! JSONStandard
                if let user_id = readableJSON["id"] {
                    //print(user_id)
                    UserDefaults.standard.set(user_id, forKey: "user_id")
                    self.userID = user_id as? String
                    if self.new {
                        self.playlistOwner = UserDefaults.standard.value(forKey: "id") as! String
                        playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).updateChildValues(["songs": self.songuris, "members" : [UserDefaults.standard.value(forKey: "id")], "owner" : UserDefaults.standard.value(forKey: "id"), "lengths" : self.lengths, "names" : self.nameList, "artists" : self.artistList])
                        self.playlists.append(UserDefaults.standard.value(forKey: "code") as! String)
                        self.names.append(self.name)
                        userNode.child(UserDefaults.standard.value(forKey: "id") as! String).updateChildValues(["owned playlist codes" : self.playlists, "owned playlist names" : self.names])
                    
                        let createPlaylistURL = "https://api.spotify.com/v1/users/\(user_id)/playlists"
                        AF.request(createPlaylistURL, method: .post, parameters: ["name" : self.name, "description" : "", "public" : true],encoding: JSONEncoding.default, headers: self.parameters).responseData {
                            response in
                            do {
                                var readableJSON = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! JSONStandard
                                if let playlist_id = readableJSON["uri"] {
                                    self.playlistID = playlist_id as? String
                                    playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).updateChildValues(["uri" : playlist_id])
                                }
                            }catch{
                                print(error)
                            }
                            
                            switch response.result {
                            case .success:
                                let addTracksURL = "https://api.spotify.com/v1/playlists/\(self.playlistID!)/tracks"
                                AF.request(addTracksURL, method: .post, parameters: ["uris" : self.songuris],encoding: JSONEncoding.default, headers: self.parameters).responseData {
                                    response in
                                    switch response.result {
                                    case .success:
                                        self.success()
                                    case .failure(let error):
                                        print(error)
                                        self.showError(title: "Error:", message: "Unable to add songs to playlist")
                                    }
                                }
                            case .failure(let error):
                                print(error)
                                self.showError(title: "Error:", message: "Unable to create playlist")
                            }
                        }
                    } else {
                        playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                            let dict = snapshot.value as! [String : Any]
                            self.playlistOwner = dict["owner"] as! String
                            var toAdd : [String] = []
                            var addLengths : [Int] = []
                            var addNames : [String] = []
                            var addArtists : [String] = []
                            if let currentSongs = dict["songs"] as? [String] {
                                //print(currentSongs)
                                toAdd = currentSongs
                            }
                            if let currentLengths = dict["lengths"] as? [Int] {
                                addLengths = currentLengths
                            }
                            if let currentNames = dict["names"] as? [String] {
                                addNames = currentNames
                            }
                            if let currentArtists = dict["artists"] as? [String] {
                                addArtists = currentArtists
                            }
                            toAdd.append(contentsOf: self.songuris)
                            addLengths.append(contentsOf: self.lengths)
                            addNames.append(contentsOf: self.nameList)
                            addArtists.append(contentsOf: self.artistList)
                            //print(toAdd)
                            playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).updateChildValues(["songs": toAdd, "lengths" : addLengths, "names" : addNames, "artists" : addArtists])
                            self.playlistID = dict["uri"] as! String
                            self.name = dict["name"] as! String
                            self.success()
                        })
                    }
                }
            }catch{
                print(error)
            }
            
            switch response.result {
            case.success:
                print("success!")
            case.failure(let error):
                print(error)
                
            }
            
            
        })
    }
    
    func success() {
        let db = Database.database().reference()
        let playlistNode = db.child("playlists")
        
        if new {
            playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).updateChildValues(["songs": self.songuris])
        }
        //performSegue(withIdentifier: "createdPlaylist", sender: self)
        //hopefully will go to root
        //self.navigationController?.popToRootViewController(animated: false)
        self.tabBarController?.selectedIndex = 1
        let navController = self.tabBarController?.viewControllers![1] as! UINavigationController
        let resultVC = CurrentPlaylistViewController()
        resultVC.code = UserDefaults.standard.value(forKey: "code") as! String
        resultVC.playlist = Playlist(id: playlistID!, playlist: ["name": name, "code": UserDefaults.standard.value(forKey: "code"), "songs": selectedSongs, "owner" : self.playlistOwner])
        resultVC.owner = self.owner
        var toSend = previousSongs
        toSend.append(contentsOf: selectedSongs)
        //print("songs that are being passed")
        //print(toSend)
        resultVC.songs = toSend
        loadingIcon.stopAnimating()
        navController.popToRootViewController(animated: false)
        //self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
        navController.pushViewController(resultVC, animated: true)
    }
    
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
