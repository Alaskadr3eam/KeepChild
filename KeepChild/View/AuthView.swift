//
//  AuthView.swift
//  KeepChild
//
//  Created by Clément Martin on 13/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class AuthView: UIView {
    
    @IBOutlet weak var emailLoginTextField: CustomTextField!
    @IBOutlet weak var passwordLoginTextField: CustomTextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var gradientLayer: CAGradientLayer!
    // MARK: - Properties
    var registration: Bool! {
        didSet {
          submitButtonDisplay()
        }
    }
    
    private func submitButtonDisplay() {
        //guard let titleButton = submitButton.titleLabel else { return }
        registration ? (submitButton.setTitle("Enregistrer", for: .normal)) : (submitButton.setTitle("Soumettre", for: .normal))
    }
    var authViewDelegate: AuthViewDelegate?
    
   /* @IBAction func logingDidTouch() {
        authViewDelegate?.loginButtonIsListenner()
    }
    
    @IBAction func signUpDidTouch() {
        authViewDelegate?.signUpButtonIsListenner()
    }*/
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            registration = false
        case 1:
            registration = true
        default:
            break
        }
    }

    @IBAction func submitButtonPressed(_ sender: AnyObject) {
        submitButton.isEnabled = false
        switch checkForm() {
        case .accepted:
            //registration ? createUser() : authenticateUser()
            registration ? authViewDelegate?.createUser() : authViewDelegate?.authenticateUser()
        case .rejeted(let error):
            authViewDelegate?.errorDetected(error: error)
            submitButton.isEnabled = true
        }
    }

    func setDesign() {
        registration = false
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)], for: .normal)
        
        guard let emailImage = Constants.Image.envelope else { return }
        emailLoginTextField.setIcon(emailImage)
        guard let passwordImage = Constants.Image.lock else { return }
        passwordLoginTextField.setIcon(passwordImage)
    }

    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.bounds
        guard let bleu = Constants.Color.bleu else { return }
        gradientLayer.colors = [bleu.cgColor, UIColor.white.cgColor, bleu.cgColor]
        self.layer.insertSublayer(gradientLayer, at: 0)
        //self.view.layer.addSublayer(gradientLayer)
    }
    
    private func checkForm() -> FromError {
        
        if emailLoginTextField.text == nil || emailLoginTextField.text == "" {
            return .rejeted(NSLocalizedString("entrer email", comment: ""))
        }
        if passwordLoginTextField.text == nil || passwordLoginTextField.text == "" {
            return .rejeted(NSLocalizedString("entrer mot de passe", comment: ""))
        }
        if passwordLoginTextField.text!.count < 6 {
            return .rejeted(NSLocalizedString("mot de passe doit avoir 6 charactères", comment: ""))
        }
        return .accepted
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
    func authenticateUser()
    func createUser()
    func errorDetected(error: String)
   // func loginButtonIsListenner()
    //func signUpButtonIsListenner()
}

enum FromError {
    case accepted
    case rejeted(String)
}
