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
    var posts = [post]()
    var temp: [Song] = []
    var selectedSongs: [Song] = []
    var imageList: [UIImage] = []
    var uris : [String] = []
    var checked : [Bool] = []
    
    var searchURL = String()
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
        selectedSongs.append(contentsOf: temp)
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
        for song in selectedSongs {
            songuris.append(song.id)
        }
        
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
    
}
