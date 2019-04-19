//
//  CreateNewPlaylistViewController.swift
//  Ditto
//
//  Created by Sam Lee on 4/11/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import SwiftyJSON

struct post {
    let mainImage : UIImage!
    let name : String!
    let artist: String!
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
    
    var name : String!
    var userID: String!
    var playlistID: String!
    var posts = [post]()
    var temp: [Song] = []
    var selectedSongs: [Song] = []
    var imageList: [UIImage] = []
    var uris : [String] = []
    var checked : [Bool] = []
    
    var searchURL = String()
    //var createPlaylistURL = "https://api.spotify.com/v1/playlists"
    var getUserURL = "https://api.spotify.com/v1/me"
    let parameters: HTTPHeaders = ["Accept":"application/json", "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "accessToken")!)"]
    typealias JSONStandard = [String : AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pickedSongs))
        setUpBackground()
        setUpSearchBar()
        setUpTable()
        searchBar.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        //callAlamo(url: searchURL, headers: parameters)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("clicked")
        let keywords = searchBar.text
        let finalKeywords = keywords?.replacingOccurrences(of: " ", with: "+")
        searchURL  = "https://api.spotify.com/v1/search?q=\(finalKeywords!)&type=track"
        posts.removeAll()
        print("printing temp")
        print(temp)
        for song in temp {
            selectedSongs.append(song)
        }
        //selectedSongs.append(contentsOf: temp)
        print(selectedSongs)
        temp.removeAll()
        
        callAlamo(url: searchURL, headers: parameters)
        self.view.endEditing(true)
    }
    
    func callAlamo(url : String, headers: HTTPHeaders){
        print("calling")
        AF.request(url, headers: parameters).responseJSON(completionHandler: {
            response in
            
            self.parseData(JSONData: response.data!)
        })
    }
    
    func parseData(JSONData : Data) {
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            
            if let tracks = readableJSON["tracks"] as? JSONStandard{
                if let items = tracks["items"] as? [JSONStandard]{
                    
                    for i in 0..<items.count {
                        
                        let item = items[i]
                        
                        let name = item["name"] as! String
                        let uri = item["uri"] as! String
                        
                        if let album = item["album"] as? JSONStandard {
                            if let images = album["images"] as? [JSONStandard] {
                                let imageData = images[0]
                                let mainImageURL = URL(string: imageData["url"] as! String)
                                let mainImageData = NSData(contentsOf: mainImageURL!)
                                
                                let mainImage = UIImage(data: mainImageData as! Data)
                                
                                let artists = album["artists"] as! [JSONStandard]
                                var artistString = ""
                                
                                for artist in artists {
                                    let artistName = artist["name"] as! String
                                    artistString += artistName + ", "
                                }
                                
                                artistString = String(artistString.dropLast(2))
                                
                                posts.append(post.init(mainImage: mainImage, name: name, artist: artistString))
                                uris.append(uri)
                                checked.append(false)
                                print("adding to table")
                                self.tableView.reloadData()
                                
                            }
                        }
                    }
                }
            }
            print(readableJSON)
        }catch{
            print(error)
        }
    }
    
    @objc func pickedSongs() {
        var songuris: [String] = []
        for song in temp {
            selectedSongs.append(song)
        }
        print(selectedSongs)
        for song in selectedSongs {
            songuris.append(song.id)
        }
        
        let db = Database.database().reference()
        let playlistNode = db.child("playlists")
        
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
                    playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).updateChildValues(["songs": songuris, "members" : [UserDefaults.standard.value(forKey: "id")]])
                    let createPlaylistURL = "https://api.spotify.com/v1/users/\(user_id)/playlists"
                    print(self.userID)
                    AF.request(createPlaylistURL, method: .post, parameters: ["name" : self.name, "description" : "", "public" : true],encoding: JSONEncoding.default, headers: self.parameters).responseData {
                        response in
                        
                        do {
                            var readableJSON = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! JSONStandard
                            if let playlist_id = readableJSON["id"] {
                                self.playlistID = playlist_id as? String
                            }
                        }catch{
                            print(error)
                        }
                        
                        switch response.result {
                        case .success:
                            print(response)
                            let addTracksURL = "https://api.spotify.com/v1/playlists/\(self.playlistID!)/tracks"
                            print(songuris)
                            AF.request(addTracksURL, method: .post, parameters: ["uris" : songuris],encoding: JSONEncoding.default, headers: self.parameters).responseData {
                                response in
                                switch response.result {
                                case .success:
                                    print("added songs")
                                    print(response)
                                    self.success(songuris: songuris)
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
    
    func success(songuris: [String]) {
        let db = Database.database().reference()
        let playlistNode = db.child("playlists")
        
        playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).updateChildValues(["songs": songuris])
        //performSegue(withIdentifier: "createdPlaylist", sender: self)
        self.tabBarController?.selectedIndex = 1
        let navController = self.tabBarController?.viewControllers![1] as! UINavigationController
        let resultVC = CurrentPlaylistViewController()
        resultVC.code = UserDefaults.standard.value(forKey: "code") as! String
        resultVC.playlist = Playlist(id: UserDefaults.standard.value(forKey: "code") as! String, playlist: ["name": name, "code": UserDefaults.standard.value(forKey: "code"), "songs": selectedSongs])
        navController.pushViewController(resultVC, animated: true)
    }
    
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
