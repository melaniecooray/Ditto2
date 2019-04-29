//
//  NewPlaylistViewController.swift
//  Ditto
//
//  Created by Sam Lee on 4/6/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class NewPlaylistViewController: UIViewController, UITextFieldDelegate {
    
    var newPlaylistTextField: UITextField!
    
    var imageView: UIImageView!
    var imagePicker: UIButton!
    
    var chosenImage: UIImage!
    
    var createButton: UIButton!
    
    var code: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "createplaylistback")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)

        
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
    
    override func viewDidAppear(_ animated: Bool) {
        createButton.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func createButtonClicked() {
        if newPlaylistTextField.text == nil || newPlaylistTextField.text == "" {
            showError(title: "Error", message: "Playlist must have a name.")
        } else {
            createButton.isEnabled = false
            let db = Database.database().reference()
            let playlistNode = db.child("playlists")
            code = makeCode()
            playlistNode.child(code).setValue(["name": newPlaylistTextField.text!, "code": code, "members": UserDefaults.standard.value(forKey: "name")])
            UserDefaults.standard.set(code, forKey: "code")
            UserDefaults.standard.set("new", forKey: "playlistStatus")
            
            //self.performSegue(withIdentifier: "toCreatePlaylist", sender: self)
            
            
            let imageRef = Storage.storage().reference().child("images").child(code)
            //let data = chosenImage!.pngData()!
            //lowest quality compression for jpeg
            if chosenImage == nil {
                self.performSegue(withIdentifier: "toCreatePlaylist", sender: self)
            } else {
                let data = chosenImage!.jpegData(compressionQuality: 0)!
                imageRef.putData(data, metadata: nil) { (metadata, error) in
                    if metadata == nil {
                        return
                    }
                    imageRef.downloadURL { (url, error) in
                        if url == nil {
                            return
                        }
                        self.performSegue(withIdentifier: "toCreatePlaylist", sender: self)
                    }
                }
                
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        print("return was pressed")
        return true
    }
    
    func makeCode() -> String {
        var key = "";
        for _ in 1...6 {
            key += String(Int.random(in: 0...9))
            //key += ((Int.random(in: 0...9) * Int(truncating: NSDecimalNumber(decimal: pow(10, num) - 1))))
        }
        let db = Database.database().reference()
        let playlistNode = db.child("playlists")
        playlistNode.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                key = self.makeCode()
            }
        })
        return key
    }
    
    func addTapDismiss() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    @objc func dismissKeyboard() {
        newPlaylistTextField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let resultVC = segue.destination as? CreateNewPlaylistTableViewController {
            resultVC.name = newPlaylistTextField.text
        }
    }
}
