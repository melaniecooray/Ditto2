//
//  Playlist.swift
//  Ditto
//
//  Created by Candace Chiang on 4/12/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit

class Playlist {
    var id: String!
    var name: String!
    //var songs: [Song] = []
    var songs: [Song] = []
    var chat: Chat!
    var code: String!
    
    //var owner: User!
    //var users: [User] = []
    
    var owner: String!
    var members: [String] = []
    
    var lastPlayed: Date!
    var created: Date!
    
    var image: UIImage!
    
    init(id: String, playlist: [String: Any]) {
        self.id = id
        self.name = playlist["name"] as? String
        //self.chat = Chat(id: playlist["chatID"] as! String, messages: [])
        //add messages later? not sure how to fetch this
        self.code = playlist["code"] as? String
        //get songs
        //self.songs = playlist["songs"] as? [Song] ?? []
        //when playing, can get each song individually
        
        self.songs = playlist["songs"] as? [Song] ?? []
        self.owner = playlist["owner"] as? String
        self.members = playlist["members"]  as? [String] ?? []
        
        //get owner
        //get users
        
//        if let timeString = playlist["lastPlayed"] as? String {
//            self.lastPlayed = timeString.toDate()
//        } else {
//            self.lastPlayed = Date.init()
//        }
//
//        if let timeString = playlist["created"] as? String {
//            self.created = timeString.toDate()
//        } else {
//            self.created = Date.init()
//        }
        
        //fetch image later
        self.image = UIImage(named: "defaultplaylist")
    }
}
