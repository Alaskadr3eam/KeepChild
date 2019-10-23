//
//  AuthViewGestion.swift
//  KeepChild
//
//  Created by Clément Martin on 22/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation

class AuthGestion {
    //MARK: - Properties
    private var firebaseServiceSession = FirebaseService(dataManager: ManagerFirebase())
    
    init(firebaseServiceSession: FirebaseService) {
        self.firebaseServiceSession = firebaseServiceSession
    }
    //MARK: - Request
    func signIn(withEmail: String, password: String, completionHandler: @escaping (Bool) -> Void) {
        firebaseServiceSession.dataManager.signIn(withEmail: withEmail, password: password) { (bool) in
            guard bool == true else {
                completionHandler(false)
                return
            }
            completionHandler(true)
        }
    }

    func signOut(completionHandler: @escaping(Bool) -> Void) {
        firebaseServiceSession.dataManager.signOut { (bool) in
            guard bool == true else {
                completionHandler(false)
                return
            }
            completionHandler(true)
        }
    }

    func createAccount(email: String, password: String, completionHandler: @escaping (Bool) -> Void) {
        firebaseServiceSession.dataManager.createAccount(email: email, password: password) { (bool) in
            guard bool == true else {
                completionHandler(false)
                return
            }
            completionHandler(true)
        }
    }

    func retrievUserConnected(completionHandler: @escaping(Bool)->Void) {
        firebaseServiceSession.dataManager.retrieveUserAuth { (bool) in
            guard bool == true else {
                completionHandler(false)
                return
            }
            completionHandler(true)
        }
    }
    
}
