//
//  EnterCodeVC.swift
//  Ditto
//
//  Created by Candace Chiang on 4/6/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import Firebase

class EnterCodeViewController: UIViewController, UITextFieldDelegate {

    var backgroundImage: UIImageView!
    var tagLabel: UILabel!
    var codeInput: UITextField!
    var searchButton: UIButton!
    
    var code = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBackground()
        setUpLabels()
        setUpInteractive()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.codeInput.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //dismiss keyboard when you press return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func codeEntered(_ sender: UITextField) {
        let possCode = sender.text
        if possCode != "" {
            code = possCode!.uppercased()
        }
    }
    
    @objc func filter(_ sender: UIButton) {
        //actually filter here?
        if code == "" {
            showError(title: "Invalid", message: "Please enter in a playlist code.")
            return
        } else if code.count != 6 {
            showError(title: "Invalid", message: "A playlist code is 6 characters.")
            return
        } else if code.contains(" ") {
            showError(title: "Invalid", message: "A playlist code cannot have spaces.")
        }
        let db = Database.database().reference()
        let playlistNode = db.child("playlists")
        playlistNode.observeSingleEvent(of: .value, with: { (snapshot) in
            for playlist in snapshot.children {
                let newPlaylist = playlist as! DataSnapshot
                let dict = newPlaylist.value as! [String : Any]
                let codeCheck = dict["code"] as! String
                print(self.code)
                print(dict["code"]!)
                if (self.code as! String == codeCheck) {
                    print("code worked")
                    UserDefaults.standard.set(self.code, forKey: "code")
                    self.codeWorked()
                    
                    
//                    DispatchQueue.main.async {
//                        self.performSegue(withIdentifier: "toPreview", sender: self)
//                    }
                    //self.performSegue(withIdentifier: "toPreview", sender: self)
                }
            }
        })
        //showError(title: "Invalid", message: "A playlist with that code does not exist.")
        //performSegue(withIdentifier: "toPreview", sender: self)
    }
    
    func codeWorked() {
        //self.present(PreviewPlaylistViewController(), animated: true, completion: nil)
        //self.navigationController?.pushViewController(PreviewPlaylistViewController, animated: true)
        performSegue(withIdentifier: "toPreview", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPreview"  {
                
                if let childVC = navController.topViewController as? PreviewPlaylistViewController {
                    childVC.code  = code
                    //TODO: access here chid VC  like childVC.yourTableViewArray = localArrayValue
                    
                    
                }
                
            }
            
        }

    }
    
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
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
