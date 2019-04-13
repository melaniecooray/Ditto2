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
    
}


class CreateNewPlaylistTableViewController: UITableViewController, UISearchBarDelegate {
    

    @IBOutlet var searchBar: UISearchBar!
    
    var posts = [post]()
    
    var searchURL = String()
    
    let parameters: HTTPHeaders = ["Accept":"application/json", "Authorization":"Bearer \(UserDefaults.standard.value(forKey: "accessToken")!)"]
    
    typealias JSONStandard = [String : AnyObject]
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("clicked")

        let keywords = searchBar.text
        let finalKeywords = keywords?.replacingOccurrences(of: "", with: "+")
        searchURL  = "https://api.spotify.com/v1/search?q=\(finalKeywords!)&type=track"
        posts.removeAll()
        
        callAlamo(url: searchURL, headers: parameters)
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
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
        
        let vc = segue.destination as! AudioViewController
        
        vc.image = posts[indexPath!].mainImage
        
        vc.mainSongTitle = posts[indexPath!].name
        
        print("segue was done")
        
    }
    
}
