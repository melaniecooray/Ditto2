//
//  SingUpVC - UISetup.swift
//  Ditto
//
//  Created by Melanie Cooray on 3/29/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase

extension SignUpViewController {
    
    func initUI() {
        setupLogo()
        setupNameTextField()
        setupEmailTextField()
        setupPasswordTextField()
        setupSignUpButton()
        setupLogin()
    }
    
    func setupLogo() {
        logo = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width * 3/4, height: view.frame.height/2))
        logo.center = CGPoint(x: view.frame.width/2, y: view.frame.height/4)
        logo.image = UIImage(named: "logo")
        logo.contentMode = .scaleAspectFit
        view.addSubview(logo)
    }
    
    func setupNameTextField() {
        nameTextField = SkyFloatingLabelTextField(frame: CGRect(x: 0, y: 0, width: view.frame.width * 3/4, height: view.frame.height/10))
        nameTextField.center = CGPoint(x: view.frame.width/2, y: view.frame.height * 0.45)
        nameTextField.placeholder = "Full Name"
        nameTextField.title = "Full Name"
        nameTextField.font = UIFont(name: "Roboto-Light", size: 20)
        nameTextField.selectedTitleColor = UIColor(hexString: "#7383C5")
        nameTextField.selectedLineColor = UIColor(hexString: "#7383C5")
        nameTextField.errorColor = UIColor.red
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(nameTextField)
    }
    
    func setupEmailTextField() {
        emailTextField = SkyFloatingLabelTextField(frame: CGRect(x: 0, y: 0, width: view.frame.width * 3/4, height: view.frame.height/10))
        emailTextField.center = CGPoint(x: view.frame.width/2, y: nameTextField.frame.maxY * 11/10)
        emailTextField.placeholder = "Email"
        emailTextField.title = "Email Address"
        emailTextField.font = UIFont(name: "Roboto-Light", size: 20)
        emailTextField.selectedTitleColor = UIColor(hexString: "#7383C5")
        emailTextField.selectedLineColor = UIColor(hexString: "#7383C5")
        emailTextField.errorColor = UIColor.red
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(emailTextField)
    }
    
    func setupPasswordTextField() {
        passwordTextField = SkyFloatingLabelTextField(frame: CGRect(x: 0, y: 0, width: view.frame.width * 3/4, height: view.frame.height/10))
        passwordTextField.center = CGPoint(x: view.frame.width/2, y: emailTextField.frame.maxY * 11/10)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "Password"
        passwordTextField.title = "Password"
        passwordTextField.font = UIFont(name: "Roboto-Light", size: 20)
        passwordTextField.selectedTitleColor = UIColor(hexString: "#7383C5")
        passwordTextField.selectedLineColor = UIColor(hexString: "#7383C5")
        passwordTextField.errorColor = UIColor.red
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(passwordTextField)
    }
    
    func setupSignUpButton() {
        signUpButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.42, height: view.frame.height/15))
        signUpButton.center = CGPoint(x: view.frame.width/2, y: passwordTextField.frame.maxY * 7/6)
        signUpButton.setTitle("Sign up", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 25)
        signUpButton.layer.cornerRadius = 10
        signUpButton.backgroundColor = UIColor(hexString: "7383C5")
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        view.addSubview(signUpButton)
    }
    
    func setupLogin() {
        loginText = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width/2, height: view.frame.height/16))
        loginText.center = CGPoint(x: view.frame.width/2 * 11/12, y: signUpButton.frame.maxY * 15/14)
        loginText.text = "Already have an account?"
        loginText.font = UIFont(name: "Roboto-Regular", size: 15)
        view.addSubview(loginText)
        loginButton = UIButton(frame: CGRect(x: loginText.frame.maxX * 10/11, y: loginText.frame.minY, width: view.frame.width/6, height: loginText.frame.height))
        loginButton.setTitle("Login!", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
        loginButton.setTitleColor(UIColor(hexString: "7383C5"), for: .normal)
        loginButton.addTarget(self, action: #selector(toLogin), for: .touchUpInside)
        view.addSubview(loginButton)
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if let text = textfield.text {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                floatingLabelTextField.errorMessage = ""
            }
        }
    }
    
    @objc func emailTextFieldDidChange(_ textfield: UITextField) {
        if let text = textfield.text {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                if(text.count < 5 || !text.contains("@")) {
                    floatingLabelTextField.errorMessage = "Invalid email"
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    @objc func passwordTextFieldDidChange(_ textfield: UITextField) {
        if let text = textfield.text {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                if(text.count < 6) {
                    floatingLabelTextField.errorMessage = "Invalid password"
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    @objc func toLogin() {
        performSegue(withIdentifier: "backToLogin", sender: self)
    }
    
    @objc func signUp() {
        var userName : String!
        var userEmail : String!
        var userPassword : String!
        
        if let newName = nameTextField.text {
            userName = newName
        } else {
            self.signUpButton.isUserInteractionEnabled = true
            showError(title: "Information Missing", message: "No Name Entered")
            return
        }
        
        if let em = emailTextField.text{
            if em.count > 5 && em.contains("@") {
                userEmail = em
            } else {
                self.signUpButton.isUserInteractionEnabled = true
                showError(title: "Invalid Information", message: "Email must be at least 5 characters and have an @ sign")
                return
            }
        } else {
            self.signUpButton.isUserInteractionEnabled = true
            showError(title: "Information Missing", message: "No Email Entered")
            return
        }
        
        if let pass = passwordTextField.text {
            if pass.count > 6 {
                userPassword = pass
            } else {
                self.signUpButton.isUserInteractionEnabled = true
                showError(title: "Invalid Information", message: "Password must be at least 6 characters")
                return
            }
        } else {
            self.signUpButton.isUserInteractionEnabled = true
            showError(title: "Information Missing", message: "No Password Entered")
            return
        }

        
        signUpButton.isEnabled = false
        signUpButton.backgroundColor = .gray
        signUpButton.setTitle("Loading...", for: .normal)
        
        Auth.auth().createUser(withEmail: userEmail!, password: userPassword!, completion: { (user, error) in
            if let error = error {
                self.signUpButton.isUserInteractionEnabled = true
                print(error)
                self.showError(title: "Error:", message: "Could not register user.")
                return
            } else {
                guard (user?.user.uid) != nil else {
                    return
                }
                
                
                let ref = Database.database().reference()
                let id = user?.user.uid
                let userRef = ref.child("users").child(id!)
//                let id =
                //added
                UserDefaults.standard.setValue(id, forKey: "id")
                print(UserDefaults.standard.value(forKey: "id")!)
                let values = ["Name": userName, "Email": userEmail]
                
//                self.id = id
//                
//                var user: [String: Any] = [:]
//                user["name"] = self.userName
//                user["lastName"] = self.lastName
//                user["email"] = self.userEmail
//                user["userFriends"] = friends
                
                //ref.setValue(values)
                
                
                //added
                
                userRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        print(error)
                        return
                    } else {
                        self.performSegue(withIdentifier: "signedUp", sender: self)
                    }
                })
            }
        })
    }
    
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
