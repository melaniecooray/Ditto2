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
        
        //downloadFileFromURL(url: URL(string: mainPreviewURL)!)
    }
    
    //    func downloadFileFromURL(url: URL) {
    //        var downloadTask = URLSessionDownloadTask()
    //        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: {
    //            customURL, response, error in
    //
    //            self.play(url: customURL!)
    //        })
    //
    //        downloadTask.resume()
    //    }
    //
    //    func play(url: URL) {
    //        do {
    //            player = try AVAudioPlayer(contentsOf: url)
    //            player.prepareToPlay()
    //            player.play()
    //        }
    //        catch {
    //            print(error)
    //        }
    //    }
    
    
    


}
