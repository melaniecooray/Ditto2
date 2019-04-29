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
        
        setUpSearchBar()
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
        recentlyPlayedLabel.center = CGPoint(x: view.frame.width/1.11, y: tableView.frame.minY * 0.90 )
        recentlyPlayedLabel.font = UIFont(name: "Roboto-Bold", size: 20)
        recentlyPlayedLabel.text = "all playlists"
        view.addSubview(recentlyPlayedLabel)
    }
    
    func setUpTable() {
        tableView = UITableView(frame: CGRect(x: 0, y: view.frame.height/4, width: view.frame.width, height: view.frame.height - view.frame.height/5))
        tableView.register(PlaylistViewCell.self, forCellReuseIdentifier: "tableCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.rowHeight = view.frame.height/8
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.frame.height/8, right: 0)
        tableView.separatorColor = UIColor.white
        tableView.allowsSelection = false
        view.addSubview(tableView)
    }
    
    func setUpSearchBar() {
        mainSearchBar = UISearchBar(frame: CGRect(x: view.frame.width * 0.15, y: view.frame.height/8.5, width: view.frame.width * 3.5/5, height: view.frame.width/6))
        
        mainSearchBar.placeholder = "   search for a playlist..."
        mainSearchBar.backgroundColor = UIColor.clear
        mainSearchBar.tintColor = UIColor.clear
        mainSearchBar.barTintColor = UIColor.clear
        mainSearchBar.backgroundImage = UIImage()
        mainSearchBar.scopeBarBackgroundImage = UIImage()
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .clear
        mainSearchBar.isTranslucent = true
        
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        let textFieldInsideSearchBar = mainSearchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.black
        
        view.addSubview(mainSearchBar)
    }
    
    func setupEmptyLabel() {
        emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        emptyLabel.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        emptyLabel.text = "No joined playlists"
        emptyLabel.font = UIFont(name: "Roboto-Bold", size: 20)
        view.addSubview(emptyLabel)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        searchBar.resignFirstResponder()
    }
    
    
    
}
