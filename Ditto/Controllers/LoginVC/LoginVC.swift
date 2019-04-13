//
//  LoginVC.swift
//  Ditto
//
//  Created by Melanie Cooray on 3/16/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase

class LoginViewController: UIViewController {
    
    var scrollView: UIScrollView!
    
    var code: UITextField!
    var joinButton: UIButton!
    
    var logo: UIImageView!
    
    var emailTextField : SkyFloatingLabelTextField!
    var passwordTextField : SkyFloatingLabelTextField!
    
    var loginButton: UIButton!
    
    var signUpText: UILabel!
    var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                print("logged in")
                self.alreadySignedIn()
            } else {
                self.initUI()
                self.addTapDismiss()
            }
        }
        initUI()
        addTapDismiss()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func addTapDismiss() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    @objc func dismissKeyboard() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        code.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                if !code.isEditing {
                    self.view.frame.origin.y -= 200
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func login() {
        var userUsername: String?
        var userPassword: String?
        
        if let usern = emailTextField.text {
            userUsername = usern
        }
        
        if let pass = passwordTextField.text {
            userPassword = pass
        }
        
        if emailTextField.text == "" {
            self.loginButton.isUserInteractionEnabled = true
            showError(title: "Information Missing", message: "No Username Entered")
            return
        }
        
        if passwordTextField.text == "" {
            self.loginButton.isUserInteractionEnabled = true
            showError(title: "Information Missing", message: "No Password Entered")
            return
        }
        
        loginButton.isEnabled = false
        loginButton.backgroundColor = .gray
        loginButton.setTitle("Loading...", for: .normal)
        
        Auth.auth().signIn(withEmail: userUsername!, password: userPassword!, completion: { (user, error) in
            if let error = error {
                self.loginButton.isUserInteractionEnabled = true
                self.loginButton.isEnabled = true
                self.loginButton.backgroundColor = UIColor(hexString: "7383C5")
                self.loginButton.setTitle("Login", for: .normal)
                print(error)
                self.showError(title: "Error:", message: "Could not sign in user.")
                return
            } else {
                self.performSegue(withIdentifier: "loggedIn", sender: self)
            }
        })
    }
    
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func alreadySignedIn() {
        performSegue(withIdentifier: "loggedIn", sender: self)
    }

}
