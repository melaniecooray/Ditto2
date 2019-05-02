//
//  AudioViewController.swift
//  Ditto
//
//  Created by Sam Lee on 4/12/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class AudioViewController : UIViewController {
    
    var image = UIImage()
    var mainSongTitle =  String()
    //var mainPreviewURL = String()
    
    
   
    @IBOutlet var background: UIImageView!
    
    
    @IBOutlet var mainImageView: UIImageView!
    
    @IBOutlet var songTitle: UILabel!
    
    
    override func viewDidLoad() {
        
        songTitle.text = mainSongTitle
        mainImageView.image = image
        background.image = image
        
    }
    

    
    
    


}
