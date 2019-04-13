//
//  User.swift
//  Ditto
//
//  Created by Candace Chiang on 4/2/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import Foundation

class User {
    var id: String!
    var name: String!
    var playlists: [String] = []
    //fetch each playlist one by one as unneeded
    var created: Date!
    
    //don't need to get playlists at first
    init(id: String, user: [String: Any]) {
        self.id = id
        self.name = user["name"] as? String
        if let timeString = user["created"] as? String {
            self.created = timeString.toDate()
        } else {
            self.created = Date.init()
        }
    }
    
    func getPlaylists() {
        //get playlists if on profile (but if in chat, unneeded)
    }
    
}
