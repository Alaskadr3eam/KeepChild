//
//  AuthViewController.swift
//  KeepChild
//
//  Created by Clément Martin on 13/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI
import CoreLocation

class AuthViewController: UIViewController, FUIAuthDelegate {
    //MARK: - Properties
    @IBOutlet weak var authView: AuthView!
    //model for vc

    var authGestion = AuthManager(firebaseServiceSession: FirebaseService(dataManager: ManagerFirebase()))
    var profilGestion = ProfileManager(firebaseServiceSession: FirebaseService(dataManager: ManagerFirebase()))
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        authView.setDesign()
        authView.authViewDelegate = self
        initLocationManager()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authView.createGradientLayer()
        if CurrentUserManager.shared.profil != nil {
            performSegue(withIdentifier: Constants.Segue.segueLoginToList, sender: nil)
        } else {
            retrieveUserAuth()
        }
    }
    
    private func initLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func retrieveUserAuth() {
        authGestion.retrievUserConnected { [weak self] (bool) in
            guard let self = self, bool == true else { return }
            //search profil user for add singleton CurrentUserManager
            self.retrieveProfil()
            self.authView.emailLoginTextField.text = nil
            self.authView.passwordLoginTextField.text = nil
        }
    }
    //func retrieve profilUser if existing
    func retrieveProfil() {
        let idUser = CurrentUserManager.shared.user.senderId
        profilGestion.retrieveProfilUser(field: "idUser", equal: idUser) { [weak self] (error,bool) in
            guard let self = self else { return }
            guard error == nil else {
                self.presentAlert(title: "Erreur", message: "Problème de connexion")
                return
            }
            guard bool == true else {
                self.performSegue(withIdentifier: "EditProfil", sender: nil)
                return
            }
            self.performSegue(withIdentifier: Constants.Segue.segueLoginToList, sender: nil)
        }
    }
    //MARK: - Action
    @IBAction func saveToMainViewController (segue:UIStoryboardSegue) {
        _ = segue.source as! ProfilTableViewController
        authGestion.signOut { [weak self] (bool) in
            guard let self = self else { return }
            guard bool == true else {
                self.presentAlert(title: "Sign Out Failed", message: "Vérifiez votre connexion")
                return
            }
            CurrentUserManager.shared.removeUserAndProfilWhenLogOut()
        }
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.segueLoginToList {
            if segue.destination is ProfilTableViewController {
            }
        }
        if segue.identifier == Constants.Segue.segueEditProfil {
            if segue.destination is EditProfilTableViewController {
                
            }
        }
    }
}

extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case authView.emailLoginTextField:
            moveTextField(authView.passwordLoginTextField, moveDistance: 0, up: false)
        case authView.passwordLoginTextField:
            moveTextField(authView.passwordLoginTextField, moveDistance: Constants.MoveTextField.movePasswordTextfield, up: true)
        default:break
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case authView.emailLoginTextField:
            moveTextField(authView.passwordLoginTextField, moveDistance: 0, up: false)
            authView.emailLoginTextField.resignFirstResponder()
        case authView.passwordLoginTextField:
            moveTextField(authView.passwordLoginTextField, moveDistance: Constants.MoveTextField.movePasswordTextfield, up: false)
            authView.passwordLoginTextField.resignFirstResponder()
        default:break
        }
        return true
    }
    
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
}

extension AuthViewController: AuthViewDelegate {
    func errorDetected(error: String) {
        presentAlert(title: "Attention", message: error)
    }
    
    func authenticateUser() {
        guard
            let email = authView.emailLoginTextField.text,
            let  password = authView.passwordLoginTextField.text,
            email.count > 0,
            password.count > 0
            else { return }
        authGestion.signIn(withEmail: email, password: password) { [weak self] (bool) in
            guard let self = self else { return }
            guard bool == true else {
                self.presentAlert(title: "Sign In Failed", message: "Echec de l'authentification")
                return
            }
            self.retrieveProfil()
        }
        self.authView.submitButton.isEnabled = true
    }
    
    func createUser() {
        guard
            let email = authView.emailLoginTextField.text,
            let  password = authView.passwordLoginTextField.text,
            email.count > 0,
            password.count > 0
            else { return }
        authGestion.createAccount(email: email, password: password) { [weak self] (bool) in
            guard let self = self else { return }
            guard bool == true else {
                self.presentAlert(title: "Create account Failed", message: "Vérifiez votre connexion. Si le problème persiste contactez l'administrateur")
                return
            }
            guard let email = self.authView.emailLoginTextField.text else { return }
            guard let password = self.authView.passwordLoginTextField.text else { return }
            Auth.auth().signIn(withEmail: email, password: password)
        }
    }
}


