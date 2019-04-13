//
//  PlaylistsVC - UISetup.swift
//  Ditto
//
//  Created by Sam Lee on 4/6/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit

extension PlaylistsViewController {
    
    func setUpBackground() {
        backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 2 / 3))
        backgroundImage = UIImageView(frame: view.frame)
        backgroundImage.image = UIImage(named: "playlistbackground")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.5
        view.addSubview(backgroundImage)
    }
    
    func setUpAddButton() {
        addButton = UIButton(frame: CGRect(x: view.frame.width - view.frame.width / 7, y: view.frame.height / 12, width: view.frame.width / 12, height: view.frame.width / 12))
        let image = UIImage(named: "plus")
        addButton.setImage(image, for: .normal)
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        view.addSubview(addButton)
    }
    
    func setUpLabel() {
        recentlyPlayedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 10))
        recentlyPlayedLabel.center = CGPoint(x: view.frame.width/1.18, y: tableView.frame.minY * 0.90 )
        recentlyPlayedLabel.font = UIFont(name: "Roboto-Bold", size: 20)
        recentlyPlayedLabel.text = "recently played"
        view.addSubview(recentlyPlayedLabel)
    }
    
    func setUpTable() {
        tableView = UITableView(frame: CGRect(x: 0, y: view.frame.height/4, width: view.frame.width, height: view.frame.height - view.frame.height/10))
        tableView.register(PlaylistViewCell.self, forCellReuseIdentifier: "tableCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        //tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = view.frame.height/8
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.frame.height/8, right: 0)
        tableView.separatorColor = UIColor.white
        //tableView.separatorStyle
        view.addSubview(tableView)
    }
    
    func setUpSearchBar() {
        mainSearchBar = UISearchBar(frame: CGRect(x: view.frame.width / 4, y: view.frame.height/8.5, width: view.frame.width, height: view.frame.width/6))
//        pokemonTable.contentInset = UIEdgeInsetsMake(view.frame.height/30, 0, self.tabBarController!.tabBar.frame.height - view.frame.height/50, 0)
        mainSearchBar.placeholder = "search for a playlist..."
        mainSearchBar.backgroundColor = UIColor.white
        
        mainSearchBar.tintColor = UIColor.white
        mainSearchBar.barTintColor = UIColor.white
        mainSearchBar.backgroundImage = UIImage()
        mainSearchBar.layer.borderColor = UIColor.white.cgColor
        //mainSearchBar.layer.borderColor = UIImage()
//        mainSearchBar.layer.borderWidth = 1
//        
//        mainSearchBar.layer.borderColor = UIColor.clear
        mainSearchBar.isTranslucent = true
        //mainSearchBar = UISearchBar.Style(minimal)
        let textFieldInsideSearchBar = mainSearchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.black
        
        view.addSubview(mainSearchBar)
    }
    
    
    
}
