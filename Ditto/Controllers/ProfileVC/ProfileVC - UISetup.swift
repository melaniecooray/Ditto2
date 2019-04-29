//
//  ProfileVC - UISetup.swift
//  Ditto
//
//  Created by Melanie Cooray on 4/6/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import FirebaseStorage

extension ProfileViewController {
    
    func initUI() {
        setUpBackground()
        setupSignOutButton()
        setupProfilePic()
        setupName()
        setupControl()
        setupTable()
    }
    
    func setUpBackground() {
        backgroundImage = UIImageView(frame: view.frame)
        backgroundImage.image = UIImage(named: "profilebackground")
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
    }
    
    func setupSignOutButton() {
        signOutButton = UIButton(frame: CGRect(x: view.frame.maxX - view.frame.width/3.5, y: view.frame.height/20, width: 100, height: 30))
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.setTitleColor(UIColor(hexString: "ffffff"), for: .normal)
        signOutButton.layer.cornerRadius = 10
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        view.addSubview(signOutButton)
    }
    
    func setupProfilePic() {
        profilePic = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width/2 - 50, height: view.frame.width/2 - 50))
        profilePic.center = CGPoint(x: view.frame.width/2, y: view.frame.height/4)
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        view.addSubview(profilePic)
    }
    
    func setupName() {
        nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 100, height: 100))
        nameLabel.center = CGPoint(x: view.frame.width/2, y: profilePic.frame.maxY + 50)
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: "Roboto-Bold", size: 25)
        nameLabel.numberOfLines = 0
        //nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textColor = UIColor(hexString: "7383C5")
        view.addSubview(nameLabel)
    }
    
    func setupControl() {
        let items = ["Owner", "Member"]
        customSC = UISegmentedControl(items: items)
        customSC.frame = CGRect(x: 0, y: 0, width: 200, height: 25)
        customSC.center = CGPoint(x: view.frame.width/2, y: nameLabel.frame.maxY)
        customSC.selectedSegmentIndex = 0
        customSC.layer.cornerRadius = 5;
        customSC.tintColor = UIColor(hexString: "7383C5")
        customSC.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
        view.addSubview(customSC)
    }
    
    func setupTable() {
        tableView = UITableView(frame: CGRect(x: 0, y: customSC.frame.maxY + view.frame.height/40, width: view.frame.width, height: view.frame.maxY - customSC.frame.maxY))
        tableView.register(PlaylistViewCell.self, forCellReuseIdentifier: "PlaylistCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.rowHeight = view.frame.height/8
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.frame.height/8, right: 0)
        tableView.separatorColor = UIColor.white
        view.addSubview(tableView)
    }
    
    func setUpImagePicker() {
        
        imagePicker = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width/2 - 50, height: view.frame.width/2 - 50))
        imagePicker.center = CGPoint(x: view.frame.width/2, y: view.frame.height/4)
        imagePicker.imageView?.contentMode = .scaleAspectFill
        imagePicker.imageView?.setRounded()
        imagePicker.layer.cornerRadius = imagePicker.frame.height/2
        imagePicker.clipsToBounds = true
        imagePicker.layer.masksToBounds = false
        imagePicker.addTarget(self, action: #selector(openImageOptions), for: .touchUpInside)
        
        //default
        let imagesRef = Storage.storage().reference().child("images")
        let image = imagesRef.child(currentID)
        
        //profile pic
        image.getData(maxSize: 30 * 1024 * 1024) { data, error in
            if let error = error {
                self.imagePicker.setImage(UIImage(named: "profilepicdefault-1"), for: .normal)
                self.imagePicker.imageView?.setRounded()
            } else {
                self.imagePicker.setImage(UIImage(data: data!), for: .normal)
                self.imagePicker.imageView?.setRounded()
            }
        }
        
        view.addSubview(imagePicker)
        
        imageView = UIImageView(frame: CGRect(x: view.frame.width * 0.52, y: imagePicker.frame.maxY - view.frame.height/20, width: view.frame.width/8, height: view.frame.width/8))
        //imageView.image = UIImage(named: "click")
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
    }
    
}
