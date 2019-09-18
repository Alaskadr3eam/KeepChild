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

    @IBOutlet weak var authView: AuthView!
    var loginToList = "LoginToList"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authView.authViewDelegate = self
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                guard let id = user?.uid else { return }
                UserDefaults.standard.set(id, forKey: "userID")
                self.performSegue(withIdentifier: self.loginToList, sender: nil)
                self.authView.emailLoginTextField.text = nil
                self.authView.passwordLoginTextField.text = nil
            }
        }

    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
   /*     if Auth.auth().currentUser != nil {
            //do something :D
        } else {
            let authUI = FUIAuth.defaultAuthUI()
            authUI?.delegate = self
            let providers: [FUIAuthProvider] = [
                FUIGoogleAuth()]
            
            authUI?.providers = providers
            let authViewController = authUI!.authViewController()
            self.present(authViewController, animated: true, completion: nil)
        }*/
    }

    
    @IBAction func saveToMainViewController (segue:UIStoryboardSegue) {
        let profilViewController = segue.source as! ProfilTableViewController
       try! Auth.auth().signOut()
        
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == loginToList {
            if let vcDestination = segue.destination as? ProfilTableViewController {
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
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
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error, user == nil {
                let alert = UIAlertController(title: "Sign In Failed", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func signUpButtonIsListenner() {
        let alert = UIAlertController(title: "Register", message: "Register", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let emailField = alert.textFields![0].text else { return }
            guard let passwordField = alert.textFields![1].text else { return }
            
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
