//
//  ProfileVC - Table.swift
//  Ditto
//
//  Created by Melanie Cooray on 4/6/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import Foundation
import UIKit

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(playlistTitleList.count)
        return playlistTitleList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath) as! PlaylistViewCell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        let size = CGSize(width: tableView.frame.width, height: tableView.frame.height/4)
        cell.initCellFrom(size: size)
        cell.layoutMargins = UIEdgeInsets.zero
        cell.playlistName.text = playlistTitleList[indexPath.row]
        cell.playlistName.adjustsFontSizeToFitWidth = true
        cell.playlistLastPlayed.text = playlistLastPlayed[indexPath.row]
        cell.playlistName.font = UIFont(name: "Roboto-Bold", size: 15)
        cell.playlistLastPlayed.font = UIFont(name: "Roboto-Regular", size: 12)
        cell.playlistLastPlayed.textColor = UIColor(hexString: "7383C5")
        return cell
    }
    
    
}
