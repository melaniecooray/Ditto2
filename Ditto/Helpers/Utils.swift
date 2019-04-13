//
//  Utils.swift
//  Ditto
//
//  Created by Candace Chiang on 4/2/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import Foundation

class Utils {
    static func space(text: String) -> String {
        var new = ""
        for char in text {
            new = new + " " + String(char)
        }
        return new
    }
}
