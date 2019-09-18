//
//  AuthView.swift
//  KeepChild
//
//  Created by Clément Martin on 13/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit

class AuthView: UIView {
    
    @IBOutlet weak var emailLoginTextField: UITextField!
    @IBOutlet weak var passwordLoginTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    var authViewDelegate: AuthViewDelegate?
    
    @IBAction func logingDidTouch() {
        authViewDelegate?.loginButtonIsListenner()
    }
    
    @IBAction func signUpDidTouch() {
        authViewDelegate?.signUpButtonIsListenner()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
protocol AuthViewDelegate {
    func loginButtonIsListenner()
    func signUpButtonIsListenner()
}
