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
    
}


class CreateNewPlaylistTableViewController: UITableViewController, UISearchBarDelegate {
    

    @IBOutlet var searchBar: UISearchBar!
    
    var name : String!
    var userID: String!
    var playlistID: String!
    var posts = [post]()
    var selectedSongs: [Song] = []
    var imageList: [UIImage] = []
    var uris : [String] = []
    var checked : [Bool] = []
    
    var searchURL = String()
    //var createPlaylistURL = "https://api.spotify.com/v1/playlists"
    var getUserURL = "https://api.spotify.com/v1/me"
    let parameters: HTTPHeaders = ["Accept":"application/json", "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "accessToken")!)"]
    
    typealias JSONStandard = [String : AnyObject]
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("clicked")

        let keywords = searchBar.text
        let finalKeywords = keywords?.replacingOccurrences(of: " ", with: "+")
        searchURL  = "https://api.spotify.com/v1/search?q=\(finalKeywords!)&type=track"
        posts.removeAll()
        
        callAlamo(url: searchURL, headers: parameters)
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pickedSongs))
        // Do any additional setup after loading the view, typically from a nib.
        
        //callAlamo(url: searchURL, headers: parameters)
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
                                
                                posts.append(post.init(mainImage: mainImage, name: name))
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let mainImageView = cell?.viewWithTag(2) as! UIImageView
        
        mainImageView.image = posts[indexPath.row].mainImage
        
        let mainLabel = cell?.viewWithTag(1) as! UILabel
        
        mainLabel.text = posts[indexPath.row].name
        
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (checked[indexPath[1]] == false) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            selectedSongs.append(Song(id: uris[indexPath[1]], song: ["name": posts[indexPath[1]].name, "image": posts[indexPath[1]].mainImage]))
            checked[indexPath[1]] = true
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            for num in 0..<selectedSongs.count {
                if selectedSongs[num].id == uris[indexPath[1]] {
                    selectedSongs.remove(at: num)
                    break;
                }
            }
            checked[indexPath[1]] = false
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        
        //        if let vc = segue.destination as? AudioVC {
        //            vc.image = posts[indexPath!].mainImage
        //            vc.mainSongTitle = posts[indexPath!].name
        //        }
        
        //let vc = segue.destination as! AudioViewController
        
        //vc.image = posts[indexPath!].mainImage
        
        //vc.mainSongTitle = posts[indexPath!].name
        if let resultVC = segue.destination as? PreviewPlaylistViewController {
            resultVC.code = UserDefaults.standard.value(forKey: "code") as! String
            resultVC.playlist = Playlist(id: playlistID, playlist: ["name": name, "code": UserDefaults.standard.value(forKey: "code"), "songs": selectedSongs])
        }
        
        print("segue was done")
        
    }
    
    @objc func pickedSongs() {
        
        var songuris: [String] = []
        for song in selectedSongs {
            songuris.append(song.id)
        }
        
        let db = Database.database().reference()
        let playlistNode = db.child("playlists")
        //playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).updateChildValues(["songs": songuris])
        
        
        //let jsonData = {"name" : name, "description" : "", "public" : true}
        AF.request(getUserURL, headers: parameters).responseJSON(completionHandler: {
            response in
            do {
                print("Success!!!!")
                var readableJSON = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! JSONStandard
                if let user_id = readableJSON["id"] {
                    print(user_id)
                    UserDefaults.standard.set(user_id, forKey: "user_id")
                    self.userID = user_id as? String
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
                            AF.request(addTracksURL, method: .post, parameters: ["uris" : songuris],encoding: JSONEncoding.default, headers: self.parameters).responseData {
                                response in
                                switch response.result {
                                case .success:
                                    print(response)
                                    self.performSegue(withIdentifier: "createdPlaylist", sender: self)
                                case .failure(let error):
                                    print(error)
                                    self.showError(title: "Error:", message: "Unable to add songs to playlist")
                                }
                            }
                            //self.performSegue(withIdentifier: "createdPlaylist", sender: self)
                        //break
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
        
        
        
        
        //performSegue(withIdentifier: "createdPlaylist", sender: self)
    }
    
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
