
//
//  PreviewPlaylistVCViewController.swift
//  Ditto
//
//  Created by Candace Chiang on 4/6/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit

class PreviewPlaylistViewController: UIViewController, UIScrollViewDelegate {
    
    var code: String!
    
    var colorBlock: UIView!
    var playButton: UIButton!
    var scrollPics: UICollectionView!
    
    var nameLabel: UILabel!
    var codeLabel: UILabel!
    var numberLabel: UILabel!
    var liveLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackground()
        setUpLabels()
        setUpProfiles()
        // Do any additional setup after loading the view.
    }
    
    @objc func toPlaylist(_ sender: UIButton) {
        //performSegue(withIdentifier: "toPlaylist", sender: self)
        let currentVC = CurrentPlaylistViewController()
        currentVC.code = code
        present(currentVC, animated: true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

