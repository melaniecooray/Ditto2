//
//  NewPlaylistViewController.swift
//  Ditto
//
//  Created by Sam Lee on 4/6/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import Firebase

class NewPlaylistViewController: UIViewController, UITextFieldDelegate {
    
    var newPlaylistTextField: UITextField!
    
    var imageView: UIImageView!
    var imagePicker: UIButton!
    
    var chosenImage: UIImage!
    
    var createButton: UIButton!
    
    var blueBackground: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        newPlaylistSetUp()
        setUpImagePicker()
        self.navigationController?.navigationBar.isHidden = false
        addTapDismiss()
        //self.navigationController?.navigationBar.barTintColor = UIColor(red:0.45, green:0.51, blue:0.77, alpha:1.0)
        //self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = .black
        //self.navigationController?.navigationBar.isTranslucent = true
        //self.navigationController?.view.backgroundColor = UIColor(red:0.45, green:0.51, blue:0.77, alpha:1.0)

        // Do any additional f setup after loading the view.
    }
    
    
    
    @objc func createButtonClicked() {
        let db = Database.database().reference()
        let playlistNode = db.child("playlists")
        let playlistID = makeCode()
        playlistNode.child(playlistID).setValue(["name": newPlaylistTextField.text!, "code": playlistID, "members": UserDefaults.standard.value(forKey: "name")])
        performSegue(withIdentifier: "toCreatePlaylist", sender: self)
    }
    
    func makeCode() -> String {
        var key = "";
        for _ in 1...6 {
            key += String(Int.random(in: 0...9))
            //key += ((Int.random(in: 0...9) * Int(truncating: NSDecimalNumber(decimal: pow(10, num) - 1))))
        }
        return key
    }
    
    func addTapDismiss() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    @objc func dismissKeyboard() {
        newPlaylistTextField.resignFirstResponder()
    }
}
