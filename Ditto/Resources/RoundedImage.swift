//
//  RoundedImage.swift
//  Ditto
//
//  Created by Candace Chiang on 4/11/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setRounded() {
        self.layer.cornerRadius = self.frame.width / 2
        self.contentMode = .scaleAspectFit
        self.layer.masksToBounds = true
    }
}

