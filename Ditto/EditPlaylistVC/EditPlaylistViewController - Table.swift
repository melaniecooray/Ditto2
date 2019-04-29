//
//  EditPlaylistViewController - Table.swift
//  Ditto
//
//  Created by Sam Lee on 4/20/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension EditPlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredArray.count
        } else {
            return songTitleList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var song: String?
        if isSearching {
            song = filteredArray[indexPath.row]
        } else {
            song = songTitleList[indexPath.row]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! EditSongCell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        let size = CGSize(width: tableView.frame.width, height: view.frame.height/8)
        cell.initCellFrom(size: size)
        cell.songName.text = song
        cell.layoutMargins = UIEdgeInsets.zero
        cell.songArtist.text = songArtistList[indexPath.row]
        cell.songName.adjustsFontSizeToFitWidth = true
        cell.songName.font = UIFont(name: "Roboto-Bold", size: 15)
        cell.songArtist.font = UIFont(name: "Roboto-Regular", size: 12)
        cell.songArtist.textColor = UIColor(hexString: "7383C5")
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            if self.isSearching {
                let cell = tableView.cellForRow(at: indexPath) as? EditSongCell
                let text = cell?.songName.text
                let artist = cell?.songArtist.text
                
                self.filteredArray.remove(at: indexPath.row)

                var index = 0
                while self.songTitleList[index] != text {
                    index += 1
                }
                
                self.songTitleList.remove(at: index)
                self.songArtistList.remove(at: index)
                self.lengths.remove(at: index)
                self.songs.remove(at: index)
                var ind = 0
                for song in self.songs {
                    if song.name == text {
                        self.songs.remove(at: ind)
                        break
                    }
                    ind += 1
                }
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                let db = Database.database().reference()
                let playlistNode = db.child("playlists")
                var songuris : [String] = []
                for song in self.songs {
                    songuris.append(song.id)
                }
                playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).updateChildValues(["songs" : songuris, "lengths" : self.lengths])
                
            } else {
                tableView.reloadData()
                self.songTitleList.remove(at: indexPath.row)
                self.songArtistList.remove(at: indexPath.row)
                self.lengths.remove(at: indexPath.row)
                self.songs.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                
                let db = Database.database().reference()
                let playlistNode = db.child("playlists")
                var songuris : [String] = []
                for song in self.songs {
                    songuris.append(song.id)
                }
                playlistNode.child(UserDefaults.standard.value(forKey: "code") as! String).updateChildValues(["songs" : songuris, "lengths" : self.lengths])
            }
        }
        
        return [delete]
        
    }
    
    
}

