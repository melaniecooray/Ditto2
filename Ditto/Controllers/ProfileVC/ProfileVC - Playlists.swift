//
//  ProfileVC - Playlists.swift
//  Ditto
//
//  Created by Candace Chiang on 4/26/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import FirebaseStorage

extension ProfileViewController {
    func getPlaylists() {
        let imagesRef = Storage.storage().reference().child("images")

        print("time to observe")
        print(ocodes)
        print(mcodes)

        let dispatchGroup = DispatchGroup()
        for code in ocodes {
            dispatchGroup.enter()
            let image = imagesRef.child(code)
            print("getting data")
            image.getData(maxSize: 30 * 1024 * 1024) { data, error in
                if let error = error {
                    self.oimages.append(UIImage(named: "genericplaylistpicture")!)
                    print(code)
                    print("addblack")
                } else {
                    self.oimages.append(UIImage(data: data!)!)
                    print(code)
                    print("addimage")
                }
                dispatchGroup.leave()
            }
        }
        
        for code in mcodes {
            dispatchGroup.enter()
            let image = imagesRef.child(code)
            print("getting data")
            image.getData(maxSize: 30 * 1024 * 1024) { data, error in
                if let error = error {
                    self.mimages.append(UIImage(named: "genericplaylistpicture")!)
                    print(code)
                    print("addblack")
                } else {
                    self.mimages.append(UIImage(data: data!)!)
                    print(code)
                    print("addimage")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            if self.customSC.selectedSegmentIndex == 0 {
                self.playlistImageList = self.oimages
            } else {
                self.playlistImageList = self.mimages
            }
            self.tableView.reloadData()
        })
    }
}
