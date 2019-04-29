//
//  CreatePlaylistVC - UISetup.swift
//  Ditto
//
//  Created by Candace Chiang on 4/18/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit

extension CreateNewPlaylistTableViewController {
    
    func setUpBackground() {
        backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 2 / 3))
        backgroundImage = UIImageView(frame: view.frame)
        backgroundImage.image = UIImage(named: "playlistbackground")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 1
        view.addSubview(backgroundImage)
    }
    
    func setUpTable() {
        tableView = UITableView(frame: CGRect(x: 0, y: view.frame.height/5, width: view.frame.width, height: view.frame.height - view.frame.height/10))
        tableView.register(SongCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        //tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = view.frame.height/10
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.frame.height/6, right: 0)
        tableView.separatorColor = UIColor.white
        //tableView.separatorStyle
        view.addSubview(tableView)
    }
    
    func setUpSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: view.frame.width / 7, y: view.frame.height/10, width: view.frame.width * 3/4, height: view.frame.width/6))
//        searchBar.placeholder = "search for songs and artists..."
        searchBar.backgroundColor = UIColor.clear
        searchBar.tintColor = UIColor.clear
        searchBar.barTintColor = UIColor.clear
        searchBar.backgroundImage = UIImage()
        searchBar.scopeBarBackgroundImage = UIImage()
        //searchBar.showsCancelButton = true
        searchBar.isTranslucent = true
        
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
//        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.black], for: .normal)
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.black
        textFieldInsideSearchBar?.backgroundColor = UIColor.clear
        
        var searchTextField: UITextField? = searchBar.value(forKey: "searchField") as? UITextField
        if searchTextField!.responds(to: #selector(getter: UITextField.attributedPlaceholder)) {
            let attributeDict = [NSAttributedString.Key.foregroundColor: UIColor.black, ]
            searchTextField!.attributedPlaceholder = NSAttributedString(string: "search for songs and artists...", attributes: attributeDict)
            searchTextField?.clearButtonMode = .whileEditing
            
        }
        
        let glassIconView = searchTextField?.leftView as! UIImageView
        glassIconView.image = glassIconView.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        glassIconView.tintColor = UIColor.black
        
        let clearButton = searchTextField?.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        clearButton.tintColor = UIColor.black
    
        
        view.addSubview(searchBar)
    }
    
    func setupLoadingLabel() {
        loadingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        loadingLabel.center = CGPoint(x: view.frame.width/2, y: view.frame.width/2)
        loadingLabel.font = UIFont(name: "Roboto-Bold", size: 25)
        loadingLabel.text = "Loading..."
        view.addSubview(loadingLabel)
        view.bringSubviewToFront(loadingLabel)
    }
    
    
    
    
    
}
