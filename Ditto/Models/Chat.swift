//
//  Chat.swift
//  Ditto
//
//  Created by Candace Chiang on 4/12/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import Foundation

class Chat {
    var id: String!
    var messages: [Message] = []
    var allMessages: [String] = []
    
    init(id: String, messages: [String]) {
        self.id = id
        self.allMessages = messages
        //might want to fetch only like 5 at a time
        for message in messages {
            //fetch the message
            //instantiate a Message
            //messages.append(new Message)
        }
    }
    
    func getMoreMessages() {
        //start fetching from len(messages) to some other spot
    }
}
