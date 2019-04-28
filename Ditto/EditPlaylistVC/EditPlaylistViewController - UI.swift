//
//  EditPlaylistViewController - UI.swift
//  Ditto
//
//  Created by Sam Lee on 4/20/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit

extension EditPlaylistViewController {
    
    func setUpBackground() {
        backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 2 / 3))
        backgroundImage = UIImageView(frame: view.frame)
        backgroundImage.image = UIImage(named: "editback")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 1
        view.addSubview(backgroundImage)
    }
    
    func setUpAddButton() {
        //print("setting up add button")
        addButton = UIButton(frame: CGRect(x: view.frame.width - view.frame.width / 7, y: view.frame.minY + view.frame.height / 28, width: view.frame.width / 12, height: view.frame.width / 12))
        let image = UIImage(named: "editplus")
        addButton.setImage(image, for: .normal)
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        view.addSubview(addButton)
    }
    
    func setUpLabel() {
        recentlyPlayedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 10))
        recentlyPlayedLabel.center = CGPoint(x: view.frame.width/1.18, y: tableView.frame.minY * 0.90 )
        recentlyPlayedLabel.font = UIFont(name: "Roboto-Bold", size: 20)
        recentlyPlayedLabel.text = playlist.name!
        view.addSubview(recentlyPlayedLabel)
    }
    
    func setUpTable() {
        tableView = UITableView(frame: CGRect(x: 0, y: view.frame.height/4, width: view.frame.width, height: view.frame.height - view.frame.height/10))
        tableView.register(EditSongCell.self, forCellReuseIdentifier: "tableCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        //tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = view.frame.height/8
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.frame.height/7, right: 0)
        tableView.separatorColor = UIColor(hexString: "7383C5")
        //tableView.separatorStyle
        view.addSubview(tableView)
    }
    
    func setUpSearchBar() {
        mainSearchBar = UISearchBar(frame: CGRect(x: view.frame.width / 7, y: view.frame.height/10, width: view.frame.width, height: view.frame.width/6))
        mainSearchBar.placeholder = "search for songs in playlist..."
        mainSearchBar.backgroundColor = UIColor.clear
        mainSearchBar.tintColor = UIColor.clear
        mainSearchBar.barTintColor = UIColor.clear
        mainSearchBar.backgroundImage = UIImage()
        mainSearchBar.scopeBarBackgroundImage = UIImage()
        mainSearchBar.isTranslucent = true
        
        let textFieldInsideSearchBar = mainSearchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.black
        textFieldInsideSearchBar?.backgroundColor = UIColor.clear
        
        view.addSubview(mainSearchBar)
    }
    
    
    
}

