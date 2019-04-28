//
//  PlaylistsVC - Firebase.swift
//  Ditto
//
//  Created by Candace Chiang on 4/25/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import FirebaseStorage

extension PlaylistsViewController {
    func getPlaylists() {
        let imagesRef = Storage.storage().reference().child("images")
        
        print("time to observe")
        
        let dispatchGroup = DispatchGroup()
        for (title, code) in playlistCodeList {
            dispatchGroup.enter()
            let image = imagesRef.child(code)
            print("getting data")
            image.getData(maxSize: 30 * 1024 * 1024) { data, error in
                if let error = error {
                    self.playlistImageList[title] = UIImage(named: "genericplaylistpicture")
                    print(error)
                    print("addblack")
                } else {
                    self.playlistImageList[title] = UIImage(data: data!)!
                    print("addimage")
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            self.tableView.reloadData()
        })
    }
}
