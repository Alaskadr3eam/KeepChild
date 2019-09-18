//
//  FireBase.swift
//  KeepChild
//
//  Created by Clément Martin on 17/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import FirebaseAuth

class FireBase {
    static func verifyIdUser() -> String? {
        var idUserTransfer = String()
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                guard let idUser = user?.uid else { return }
                idUserTransfer = idUser
            }
        }
        return idUserTransfer
    }
}
