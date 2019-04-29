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
        code = UITextField(frame: CGRect(x: view.frame.width/18, y: view.frame.width/7, width: view.frame.width * 2/3, height: view.frame.height/13))
        code.font = UIFont(name: "Roboto-Bold", size: 20)
        code.textAlignment = .center
        code.attributedPlaceholder = NSAttributedString(string: "PLAYLIST CODE",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#BF95DC")])
        code.textColor = UIColor(hexString: "#BF95DC")
        code.layer.borderWidth = 1.0
        code.layer.borderColor = UIColor(hexString: "#BF95DC").cgColor
        code.layer.cornerRadius = 7.0
        code.keyboardType = UIKeyboardType.numberPad
        code.delegate = self

        scrollView.addSubview(code)
        joinButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width/5, height: view.frame.width/11))
        joinButton.center = CGPoint(x: (code.frame.maxX + view.frame.width)/2, y: code.frame.midY)
        joinButton.setTitle("Join", for: .normal)
        joinButton.layer.cornerRadius = 10
        joinButton.backgroundColor = UIColor(hexString: "#BF95DC")
        joinButton.addTarget(self, action: #selector(checkCode), for: .touchUpInside)
        scrollView.addSubview(joinButton)
    }
    
    func setupLogo() {
        logo = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 2/5))
        logo.center = CGPoint(x: view.frame.width/2, y: code.frame.maxY * 6/3)
        logo.image = UIImage(named: "logo")
        logo.contentMode = .scaleAspectFit
        scrollView.addSubview(logo)
    }
    
    func setupEmailTextField() {
        emailTextField = SkyFloatingLabelTextField(frame: CGRect(x: view.frame.width/8, y: logo.frame.maxY, width: view.frame.width * 3/4, height: view.frame.height/12))
        emailTextField.placeholder = "Email"
        emailTextField.title = "Email Address"
        emailTextField.font = UIFont(name: "Roboto-Light", size: 20)
        emailTextField.selectedTitleColor = UIColor(hexString: "#7383C5")
        emailTextField.selectedLineColor = UIColor(hexString: "#7383C5")
        emailTextField.errorColor = UIColor.red
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.scrollView.addSubview(emailTextField)
    }
    
    func setupPasswordTextField() {
        passwordTextField = SkyFloatingLabelTextField(frame: CGRect(x: view.frame.width/8, y: emailTextField.frame.maxY * 30/29, width: view.frame.width * 3/4, height: view.frame.height/12))
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "Password"
        passwordTextField.title = "Password"
        passwordTextField.font = UIFont(name: "Roboto-Light", size: 20)
        passwordTextField.selectedTitleColor = UIColor(hexString: "#7383C5")
        passwordTextField.selectedLineColor = UIColor(hexString: "#7383C5")
        passwordTextField.errorColor = UIColor.red
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
        self.scrollView.addSubview(passwordTextField)
    }
    
    func setupLoginButton() {
        loginButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.42, height: view.frame.height/15))
        loginButton.center = CGPoint(x: view.frame.width/2, y: passwordTextField.frame.maxY * 7/6)
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 25)
        loginButton.layer.cornerRadius = 10
        loginButton.backgroundColor = UIColor(hexString: "7383C5")
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        scrollView.addSubview(loginButton)
    }
    
    func setupSignUp() {
        signUpText = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width/2, height: view.frame.height/16))
        signUpText.center = CGPoint(x: view.frame.width/2 * 14/15, y: loginButton.frame.maxY * 15/14)
        signUpText.text = "Don't have an account?"
        signUpText.font = UIFont(name: "Roboto-Regular", size: 15)
        scrollView.addSubview(signUpText)
        signUpButton = UIButton(frame: CGRect(x: signUpText.frame.maxX * 7/8, y: signUpText.frame.minY, width: view.frame.width/6, height: signUpText.frame.height))
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
