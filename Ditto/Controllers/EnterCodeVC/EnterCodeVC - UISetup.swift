//
//  EnterCodeVC - UISetup.swift
//  Ditto
//
//  Created by Candace Chiang on 4/6/19.
//  Copyright © 2019 Melanie Cooray. All rights reserved.
//

import UIKit

extension EnterCodeViewController {
    func setUpBackground() {
        backgroundImage = UIImageView(frame: view.frame)
        backgroundImage.image = UIImage(named: "codePic")
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
    }
    
    func setUpLabels() {
        tagLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 2/3, height: view.frame.height/10))
        tagLabel.center = CGPoint(x: view.frame.width/2, y: view.frame.height * 2/5)
        tagLabel.textAlignment = .center
        tagLabel.text = "find a playlist"
        tagLabel.font = UIFont(name: "Roboto-Light", size: 30)
        view.addSubview(tagLabel)
    }
    
    func setUpInteractive() {
        codeInput = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.width * 3/5, height: view.frame.height/11))
        codeInput.center = CGPoint(x: view.frame.width * 0.42, y: view.frame.height * 1/2)
        codeInput.font = UIFont(name: "Roboto-Bold", size: 28)
        codeInput.textAlignment = .center
        codeInput.textColor = UIColor(hexString: "#BF95DC")
        codeInput.layer.borderWidth = 2.0
        codeInput.layer.borderColor = UIColor(hexString: "#BF95DC").cgColor
        codeInput.layer.cornerRadius = 7.0
        //codeInput.keyboardType = UIKeyboardType.numberPad
        codeInput.addTarget(self, action: #selector(codeEntered), for: .allEditingEvents)
        codeInput.attributedPlaceholder = NSAttributedString(string: "PLAYLIST CODE",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#BF95DC")])
        view.addSubview(codeInput)
        
        searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width/3, height: view.frame.height/18))
        searchButton.center = CGPoint(x: (codeInput.frame.maxX + view.frame.width)/2, y: codeInput.frame.midY)
        searchButton.setImage(UIImage(named: "send"), for: .normal)
        searchButton.imageView?.contentMode = .scaleAspectFit
        searchButton.addTarget(self, action: #selector(filter), for: .touchUpInside)
        view.addSubview(searchButton)
    }
}
