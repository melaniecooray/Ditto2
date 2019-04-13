//
//  ProfileVC - UISetup.swift
//  Ditto
//
//  Created by Melanie Cooray on 4/6/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit

extension ProfileViewController {
    
    func initUI() {
        setupSignOutButton()
        setupProfilePic()
        setupName()
        setupControl()
        setupTable()
    }
    
    func setupSignOutButton() {
        signOutButton = UIButton(frame: CGRect(x: 300, y: 50, width: 100, height: 30))
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.setTitleColor(UIColor(hexString: "7383C5"), for: .normal)
        signOutButton.layer.cornerRadius = 10
        view.addSubview(signOutButton)
    }
    
    func setupProfilePic() {
        profilePic = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width/2 - 50, height: view.frame.width/2 - 50))
        profilePic.center = CGPoint(x: view.frame.width/2, y: 170)
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        view.addSubview(profilePic)
    }
    
    func setupName() {
        nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 100, height: 100))
        nameLabel.center = CGPoint(x: view.frame.width/2 + 100, y: profilePic.frame.maxY + 50)
        nameLabel.text = "John Doe"
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
        customSC.center = CGPoint(x: view.frame.width/2, y: nameLabel.frame.maxY + 10)
        customSC.selectedSegmentIndex = 0
        customSC.layer.cornerRadius = 5;
        customSC.tintColor = UIColor(hexString: "7383C5")
        view.addSubview(customSC)
    }
    
    func setupTable() {
        tableView = UITableView(frame: CGRect(x: 0, y: customSC.frame.maxY, width: view.frame.width, height: view.frame.maxY - customSC.frame.maxY))
        tableView.register(PlaylistViewCell.self, forCellReuseIdentifier: "PlaylistCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.rowHeight = view.frame.height/8
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.frame.height/8, right: 0)
        tableView.separatorColor = UIColor.gray
        view.addSubview(tableView)
    }
    
}
