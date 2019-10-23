//
//  CurrentUserManager.swift
//  KeepChild
//
//  Created by Clément Martin on 26/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation

class CurrentUserManager {
    static var shared = CurrentUserManager()
    
    private init () {
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            user = User(senderId: "eP5TsXuUutNNs5U5cPPvjayFks92", email: "test@gmail.com")
        } else {
            
        }
    }
    
    var user: User!
    var profil: ProfilUser!
    
    func removeUserAndProfilWhenLogOut() {
        user = nil
        profil = nil
    }
    
    func addUser(senderId: String, mail: String) {
        user.senderId = senderId
        user.email = mail
    }
    
    func addProfil(profilUser: ProfilUser) {
        profil = profilUser
    }
}
