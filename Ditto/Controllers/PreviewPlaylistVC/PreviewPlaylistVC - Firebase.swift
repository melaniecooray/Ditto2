//
//  PreviewPlaylistVC - Firebase.swift
//  Ditto
//
//  Created by Candace Chiang on 4/24/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

extension PreviewPlaylistViewController {
    func getMembers() {
        let membersRef = Database.database().reference().child("playlists").child(code)
        let imagesRef = Storage.storage().reference().child("images")
        
        
        membersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let dispatchGroup = DispatchGroup()
            let playlistInfo = snapshot.value as? [String: Any] ?? [:]
            let memberIDs = playlistInfo["members"] as? [String] ?? []
            for id in memberIDs {
                dispatchGroup.enter()
                let image = imagesRef.child(id)
                image.getData(maxSize: 30 * 1024 * 1024) { data, error in
                    if let error = error {
                        self.memberPics.append(UIImage(named: "profilepicdefault-1")!)
                        print("added1")
                    } else {
                        self.memberPics.append(UIImage(data: data!)!)
                        print("added2")
                    }
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                print("setUpProfiles")
                self.setUpProfiles()
            })
        })
    }
}
