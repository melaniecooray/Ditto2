//
//  CreatePlaylistVC - Table.swift
//  Ditto
//
//  Created by Candace Chiang on 4/18/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit

extension CreateNewPlaylistTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SongCell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        let size = CGSize(width: tableView.frame.width, height: view.frame.height/10)
        cell.initCellFrom(size: size)
        cell.songImage.image = posts[indexPath.row].mainImage
        cell.label.text = posts[indexPath.row].name
        cell.artist.text = posts[indexPath.row].artist
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (checked[indexPath[1]] == false) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            temp.append(Song(id: uris[indexPath[1]], song: ["name": posts[indexPath[1]].name, "image": posts[indexPath[1]].mainImage, "artist": posts[indexPath[1]].artist]))
            checked[indexPath[1]] = true
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            for num in 0..<selectedSongs.count {
                if selectedSongs[num].id == uris[indexPath[1]] {
                    temp.remove(at: num)
                    break;
                }
            }
            checked[indexPath[1]] = false
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

