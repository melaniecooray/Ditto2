//
//  LoginVC - UISetup.swift
//  Ditto
//
//  Created by Melanie Cooray on 3/16/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

extension LoginViewController {
    
    func initUI() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        view.addSubview(scrollView)
        setupCode()
        setupLogo()
        setupEmailTextField()
        setupPasswordTextField()
        setupLoginButton()
        setupSignUp()
    }
    
    func setupCode() {
        code = UITextField(frame: CGRect(x: 50, y: 70, width: view.frame.width - 200, height: 50))
        code.font = UIFont(name: "Roboto-Bold", size: 20)
        code.textAlignment = .center
        code.placeholder = "PLAYLIST CODE"
        code.textColor = UIColor(hexString: "#BF95DC")
        code.layer.borderWidth = 2.0
        code.layer.borderColor = UIColor(hexString: "#BF95DC").cgColor
        code.layer.cornerRadius = 7.0
        code.keyboardType = UIKeyboardType.numberPad
        /*
        code = SkyFloatingLabelTextField(frame: CGRect(x: 50, y: 50, width: view.frame.width - 200, height: 70))
        code.placeholder = "Enter Code for Quick Listen"
        code.title = "Code"
 */
        scrollView.addSubview(code)
        joinButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        joinButton.center = CGPoint(x: code.frame.maxX + 70, y: 100)
        joinButton.setTitle("Join", for: .normal)
        joinButton.layer.cornerRadius = 10
        joinButton.backgroundColor = UIColor(hexString: "#BF95DC")
        scrollView.addSubview(joinButton)
    }
    
    func setupLogo() {
        logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        logo.center = CGPoint(x: view.frame.width/2, y: 280)
        logo.image = UIImage(named: "logo")
        scrollView.addSubview(logo)
    }
    
    func setupEmailTextField() {
        emailTextField = SkyFloatingLabelTextField(frame: CGRect(x: 50, y: logo.frame.maxY - 50, width: view.frame.width - 100, height: 70))
        emailTextField.placeholder = "Email"
        emailTextField.title = "Email Address"
        emailTextField.font = UIFont(name: "Roboto-Light", size: 25)
        emailTextField.errorColor = UIColor.red
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.scrollView.addSubview(emailTextField)
    }
    
    func setupPasswordTextField() {
        passwordTextField = SkyFloatingLabelTextField(frame: CGRect(x: 50, y: emailTextField.frame.maxY + 10, width: view.frame.width - 100, height: 70))
        passwordTextField.placeholder = "Password"
        passwordTextField.title = "Password"
        passwordTextField.font = UIFont(name: "Roboto-Light", size: 25)
        passwordTextField.errorColor = UIColor.red
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
        self.scrollView.addSubview(passwordTextField)
    }
    
    func setupLoginButton() {
        loginButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width/2, height: 50))
        loginButton.center = CGPoint(x: view.frame.width/2, y: passwordTextField.frame.maxY + 80)
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 25)
        loginButton.layer.cornerRadius = 10
        loginButton.backgroundColor = UIColor(hexString: "7383C5")
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        scrollView.addSubview(loginButton)
    }
    
    func setupSignUp() {
        signUpText = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width/2, height: 50))
        signUpText.center = CGPoint(x: view.frame.width/2 - 10, y: loginButton.frame.maxY + 30)
        signUpText.text = "Don't have an account?"
        signUpText.font = UIFont(name: "Roboto-Regular", size: 15)
        scrollView.addSubview(signUpText)
        signUpButton = UIButton(frame: CGRect(x: view.frame.width/2 - 15, y: signUpText.frame.minY, width: 200, height: 50))
        signUpButton.setTitle("Sign Up!", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
        signUpButton.setTitleColor(UIColor(hexString: "7383C5"), for: .normal)
        signUpButton.addTarget(self, action: #selector(toSignUp), for: .touchUpInside)
        scrollView.addSubview(signUpButton)
    }
    
    // This will notify us when something has changed on the textfield
    @objc func textFieldDidChange(_ textfield: UITextField) {
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
    
    @objc func toSignUp() {
        performSegue(withIdentifier: "toSignUp", sender: self)
    }
    
}
