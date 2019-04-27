//
//  Song.swift
//  Ditto
//
//  Created by Candace Chiang on 4/12/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import Foundation

class Song {
    var id: String!
    var name: String!
    var artist: String!
    var image: UIImage!
    var length : Int!
    
    init(id: String, song: [String: Any]) {
        self.id = id
        self.name = song["name"] as? String
        self.artist = song["artist"] as? String
        self.image = song["image"] as? UIImage
        self.length = song["length"] as? Int
    }

    init(id: String) {
        self.id = id
    }
}
