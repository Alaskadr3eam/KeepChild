//
//  File.swift
//  KeepChild
//
//  Created by Clément Martin on 17/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation

class DetailAnnounce {
    
    var manageFireBase = ManageFireBase()
    
    var idUser = UserDefaults.standard.string(forKey: "userID")
    var announce: Announce!
    var profil: ProfilUser!
    
    func retrieveProfilUser(collection: String, field: String, equal: String, completionHandler: @escaping(Error?,[ProfilUser]?) -> Void) {
        manageFireBase.retrieveProfilUser(collection: collection, field: field, equal: equal) { [weak self] (error, profilUser) in
            guard error == nil else {
                completionHandler(error,nil)
                return
            }
            guard let self = self else { return }
            guard let profilArray = profilUser else { return }
            self.profil = profilArray[0]
            completionHandler(nil,profilArray)
        }
    }

    func deleteAnnounce(announceId: String) {
        manageFireBase.deleteAnnounce(announceId: announceId)
    }
}
