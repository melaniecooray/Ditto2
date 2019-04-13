//
//  Constants.swift
//  Ditto
//
//  Created by Melanie Cooray on 4/11/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import Foundation

struct Constants {
    static let clientID = "c5533d8484d548359b9debaf99f66073"
    static let redirectURI = URL(string: "ditto://returnafterlogin")!
    static let sessionKey = "b761df3a1be84a17b8674ad618699b7b"
}

extension Notification.Name {
    struct Spotify {
        static let authURLOpened = Notification.Name("authURLOpened")
    }
}
