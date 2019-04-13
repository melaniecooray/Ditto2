//
//  ToDate.swift
//  Ditto
//
//  Created by Candace Chiang on 4/12/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import Foundation

extension String {
    func toDate() -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss xxx"
        let date = dateFormatter.date(from: self)!
        return date
    }
}
