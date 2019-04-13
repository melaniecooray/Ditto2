//
//  PlaylistsVC - Table.swift
//  Ditto
//
//  Created by Sam Lee on 4/6/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import Foundation
import UIKit

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
        cell.playlistLastPlayed.text = playlistLastPlayed[indexPath.row]
        cell.playlistName.adjustsFontSizeToFitWidth = true
        cell.playlistName.font = UIFont(name: "Roboto-Bold", size: 15)
        cell.playlistLastPlayed.font = UIFont(name: "Roboto-Regular", size: 12)
        cell.playlistLastPlayed.textColor = UIColor(hexString: "7383C5")
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
    
}
