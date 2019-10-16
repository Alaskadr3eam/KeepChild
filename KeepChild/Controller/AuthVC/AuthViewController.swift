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

class AuthViewController: UIViewController, FUIAuthDelegate {
    //MARK: - Properties
    @IBOutlet weak var authView: AuthView!
    //model for vc
    var manageFireBase = ManageFireBase()
   // var profilGestion = ProfilGestion()

    var loginToList = "LoginToList"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        authView.authViewDelegate = self
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            //Auth.auth().signIn(withEmail: "test@gmail.com", password: "test@test")
            //Test
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CurrentUserManager.shared.profil != nil {
            performSegue(withIdentifier: loginToList, sender: nil)
        } else {
            retrieveUserAuth()
        }
    }

    private func retrieveUserAuth() {
        Auth.auth().addStateDidChangeListener() { auth, user in
            guard auth != nil else {
                return
            }
            guard user != nil else {
               return
            }
            guard let id = user?.uid else { return }
            guard let email = user?.email else { return }
            //create user in singleton for use in app
            let user = User(senderId: id, email: email)
            CurrentUserManager.shared.user = user
            //search profil user for add singleton CurrentUserManager
            self.retrieveProfil()
            self.authView.emailLoginTextField.text = nil
            self.authView.passwordLoginTextField.text = nil
        }
    }
    //func retrieve profilUser if existing
    func retrieveProfil() {
        let idUser = CurrentUserManager.shared.user.senderId
       /* DependencyInjection.shared.dataManager.retrieveProfilUser(field: "iDuser", equal: idUser) { [weak self] (error, profilUser) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard let profil = profilUser else {
                self.performSegue(withIdentifier: "EditProfil", sender: nil)
                return }
            CurrentUserManager.shared.addProfil(profilUser: profil[0])
            self.performSegue(withIdentifier: self.loginToList, sender: nil)
        }*/
        manageFireBase.retrieveProfilUser(collection: "ProfilUser", field: "iDuser", equal: idUser) { [weak self] (error, profilUser) in
            guard let self = self else { return }
            guard error == nil else { return }
            guard let profil = profilUser else {
                self.performSegue(withIdentifier: "EditProfil", sender: nil)
                return }
            CurrentUserManager.shared.addProfil(profilUser: profil[0])
            self.performSegue(withIdentifier: self.loginToList, sender: nil)
        }
        /*CurrentUserManager.shared.retrieveProfilUser(collection: "ProfilUser", field: "iDuser", equal: idUser2) { (error, profil) in
            guard error == nil else { return }
            guard profil != nil else {
                self.performSegue(withIdentifier: "EditProfil", sender: nil)
                return
            }
            self.performSegue(withIdentifier: self.loginToList, sender: nil)
        }*/
    }
    //MARK: - Action
    @IBAction func saveToMainViewController (segue:UIStoryboardSegue) {
        _ = segue.source as! ProfilTableViewController
        //DependencyInjection.shared.dataManager.signOut()
       try! Auth.auth().signOut()
        CurrentUserManager.shared.removeUserAndProfilWhenLogOut()
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == loginToList {
            if segue.destination is ProfilTableViewController {
            }
        }
        if segue.identifier == "EditProfil" {
            if segue.destination is EditProfilTableViewController {
                
            }
        }
    }
    

}
extension AuthViewController: AuthViewDelegate {
    func loginButtonIsListenner() {
        guard
            let email = authView.emailLoginTextField.text,
            let  password = authView.passwordLoginTextField.text,
        email.count > 0,
        password.count > 0
        else { return }
        /*DependencyInjection.shared.dataManager.signIn(withEmail: email, password: password) { (user) in
            guard user != nil else {
                let alert = UIAlertController(title: "Sign In Failed", message: "Echec de l'authentification", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.retrieveProfil()
        }*/
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard error == nil else {
                let alert = UIAlertController(title: "Sign In Failed", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                return
            }
            guard user != nil else { return }
            guard let id = user?.user.uid else { return }
            guard let email = user?.user.email else { return }
            CurrentUserManager.shared.addUser(senderId: id, mail: email)
            //retrieve profilUser if existing
            self.retrieveProfil()
        }
    }
    
    func signUpButtonIsListenner() {
        let alert = UIAlertController(title: "Register", message: "Register", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let emailField = alert.textFields![0].text else { return }
            guard let passwordField = alert.textFields![1].text else { return }
            
           /* DependencyInjection.shared.dataManager.createAccount(email: emailField, password: passwordField) { (user) in
                guard user != nil else { return }
                guard let email = self.authView.emailLoginTextField.text else { return }
                guard let password = self.authView.passwordLoginTextField.text else { return }
                Auth.auth().signIn(withEmail: email, password: password)
            }*/
            Auth.auth().createUser(withEmail: emailField, password: passwordField) { (user, error) in
                if error == nil {
                    guard let email = self.authView.emailLoginTextField.text else { return }
                    guard let password = self.authView.passwordLoginTextField.text else { return }
                    Auth.auth().signIn(withEmail: email, password: password)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField { (textEmail) in
            textEmail.placeholder = "Enter your email"
        }
        alert.addTextField { (textPassword) in
            textPassword.placeholder = "Enter your password"
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == authView.emailLoginTextField {
            authView.passwordLoginTextField.becomeFirstResponder()
        }
        if textField == authView.passwordLoginTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}

