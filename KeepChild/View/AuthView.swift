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
    // MARK: - Outlet
    @IBOutlet weak var emailLoginTextField: CustomTextField!
    @IBOutlet weak var passwordLoginTextField: CustomTextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    // MARK: - Properties
    var gradientLayer: CAGradientLayer!
    var authViewDelegate: AuthViewDelegate?
    var registration: Bool! {
        didSet {
            submitButtonDisplay()
        }
    }
    // MARK: - Action
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
            registration ? authViewDelegate?.createUser() : authViewDelegate?.authenticateUser()
        case .rejeted(let error):
            authViewDelegate?.errorDetected(error: error)
            submitButton.isEnabled = true
        }
    }
    
    private func submitButtonDisplay() {
        registration ? (submitButton.setTitle("Enregistrer", for: .normal)) : (submitButton.setTitle("Soumettre", for: .normal))
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
        
    }
    
    private func checkForm() -> FromError {
        if emailLoginTextField.text == nil || emailLoginTextField.text == "" {
            return .rejeted(NSLocalizedString("entrer email", comment: ""))
        }
        if passwordLoginTextField.text == nil || passwordLoginTextField.text == "" {
            return .rejeted(NSLocalizedString("entrer mot de passe", comment: ""))
        }
        guard let text = passwordLoginTextField.text else { return .rejeted("erreur")}
        if text.count < 6 {
            return .rejeted(NSLocalizedString("mot de passe doit avoir 6 charactères", comment: ""))
        }
        return .accepted
    }
}
protocol AuthViewDelegate {
    func authenticateUser()
    func createUser()
    func errorDetected(error: String)
}

enum FromError {
    case accepted
    case rejeted(String)
}
