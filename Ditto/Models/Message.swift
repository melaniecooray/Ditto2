//
//  Message.swift
//  Ditto
//
//  Created by Candace Chiang on 4/12/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import Foundation

class Message {
    var id: String!
    var sender: User!
    var message: String!
    var time: Date!
    
    init(id: String, message: [String: Any]) {
        self.id = id
        let userID = message["sender"] as? String
        //self.sender = get user by id
        self.message = message["message"] as? String
        
        if let timeString = message["time"] as? String {
            self.time = timeString.toDate()
        } else {
            self.time = Date.init()
        }
    }
}
