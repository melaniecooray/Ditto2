//
//  PlaylistsVC - Table.swift
//  Ditto
//
//  Created by Sam Lee on 4/6/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Alamofire

extension PlaylistsViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredArray.count
        } else {
            return playlistTitleList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var playlist: String?
        if isSearching {
            playlist = filteredArray[indexPath.row]
        } else {
            playlist = playlistTitleList[indexPath.row]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! PlaylistViewCell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        let size = CGSize(width: tableView.frame.width, height: view.frame.height/8)
        cell.initCellFrom(size: size)
        cell.playlistName.text = playlist
        cell.layoutMargins = UIEdgeInsets.zero
        //cell.playlistLastPlayed.text = playlistLastPlayed[indexPath.row]
        cell.playlistName.adjustsFontSizeToFitWidth = true
        cell.playlistName.font = UIFont(name: "Roboto-Bold", size: 15)
        cell.playlistLastPlayed.font = UIFont(name: "Roboto-Regular", size: 12)
        cell.playlistLastPlayed.textColor = UIColor(hexString: "7383C5")
        cell.playlistLastPlayed.text = playlistCodeList[playlist!]
        cell.playlistPhoto.image = playlistImageList[playlist!]
        print(playlistImageList)
        cell.playButton.addTarget(self, action: #selector(playCode(sender:)), for: .touchUpInside)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if mainSearchBar.text == nil || mainSearchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filteredArray = playlistTitleList.filter({$0.range(of: mainSearchBar.text!, options: .caseInsensitive) != nil})
            tableView.reloadData()
        }
    }
    
    @objc func playCode(sender: UITableViewCell) {
        guard let cell = sender.superview?.superview as? PlaylistViewCell else {
            return // or fatalError() or whatever
        }
        
        let indexPath = tableView.indexPath(for: cell)?.row
        self.tabBarController?.selectedIndex = 1
        let navController = self.tabBarController?.viewControllers![1] as! UINavigationController
        let resultVC = CurrentPlaylistViewController()
        resultVC.code = playlistCodeList[playlistTitleList[indexPath!]]!
        print(playlistCodeList[playlistTitleList[indexPath!]])
        let db = Database.database().reference()
        let playlistNode = db.child("playlists")
        
        playlistNode.child(playlistCodeList[playlistTitleList[indexPath!]]!).observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as! [String : Any]
            self.makePlaylist(dict: dict, previousMembers: dict["members"] as! [String], code: self.playlistCodeList[self.playlistTitleList[indexPath!]]!)
        })
    }
    
    func makePlaylist(dict: [String: Any], previousMembers: [String], code: String) {
        let owner = dict["owner"] as! String
        let name = dict["name"] as! String
        let id = dict["uri"] as! String
        let songuris = dict["songs"] as! [String]
        var songs: [Song] = []
        for songuri in songuris {
            songs.append(Song(id: songuri))
        }
        print("songs:")
        print(songs)
        
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
            for song in songs {
                print("song title")
                print(song.name)
            }
            print(songs)
            self.playlist = Playlist(id: id, playlist: ["code": code, "members": previousMembers, "name": name, "songs": songs, "owner": owner])
            UserDefaults.standard.set(code, forKey: "code")
            self.tabBarController?.selectedIndex = 1
            let navController = self.tabBarController?.viewControllers![1] as! UINavigationController
            let resultVC = CurrentPlaylistViewController()
            resultVC.code = UserDefaults.standard.value(forKey: "code") as! String
            resultVC.playlist = self.playlist
            resultVC.songs = songs
            navController.pushViewController(resultVC, animated: true)
        })
    }
    
}
