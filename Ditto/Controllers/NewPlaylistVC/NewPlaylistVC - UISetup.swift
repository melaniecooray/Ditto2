//
//  NewPlaylistVC - UISetup.swift
//  Ditto
//
//  Created by Sam Lee on 4/6/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import Foundation
import UIKit

extension NewPlaylistViewController {
    
    func newPlaylistSetUp() {
        


    
        newPlaylistTextField = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.width * 3/5, height: view.frame.height/18))
        newPlaylistTextField.center = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 2.55/5)
        newPlaylistTextField.font = UIFont(name: "Roboto-Light", size: 28)
        newPlaylistTextField.textAlignment = .center
        newPlaylistTextField.textColor = UIColor(hexString: "7383C5")
        newPlaylistTextField.borderStyle = UITextField.BorderStyle.none
        newPlaylistTextField.attributedPlaceholder = NSAttributedString(string: "playlist name",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "7383C5")])
        newPlaylistTextField.delegate = self
        view.addSubview(newPlaylistTextField)
        
        var bottomLine = UILabel(frame: CGRect(x: 0, y: newPlaylistTextField.frame.maxY * 1.2, width: view.frame.width * 3/5, height: 3))
        bottomLine.center = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 2.75/5)
        bottomLine.backgroundColor = UIColor(hexString: "7383C5")
        view.addSubview(bottomLine)
        
        createButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width * 2/5, height: 50))
        createButton.center = CGPoint(x: view.frame.width/2, y: view.frame.height * 3.2/5)
        createButton.setTitle("Create", for: .normal)
        createButton.titleLabel?.font = UIFont(name: "Roboto-Light", size: 25)
        createButton.setTitleColor(UIColor(hexString: "3E2450"), for: .normal)
        createButton.layer.borderColor = UIColor.black.cgColor
        createButton.layer.borderWidth = 1
        createButton.layer.cornerRadius = 10
        createButton.backgroundColor = UIColor.clear
        createButton.addTarget(self, action: #selector(createButtonClicked), for: .touchUpInside)
        view.addSubview(createButton)

        
    }
    
    func setUpImagePicker() {
        imagePicker = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width * 4/5, height: view.frame.height/4))
        imagePicker.center = CGPoint(x: view.frame.width/2, y: view.frame.height * (1.65/5))
        imagePicker.setImage(UIImage(named: "playlistdefaultpicture"), for: .normal)
        imagePicker.imageView?.contentMode = .scaleAspectFit
        imagePicker.addTarget(self, action: #selector(openImageOptions), for: .touchUpInside)
        view.addSubview(imagePicker)
        
        imageView = UIImageView(frame: CGRect(x: view.frame.width * 0.52, y: imagePicker.frame.maxY - view.frame.height/20, width: view.frame.width/8, height: view.frame.width/8))
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
    }
    
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    

}
