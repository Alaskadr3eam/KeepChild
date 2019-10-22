//
//  Profil.swift
//  KeepChild
//
//  Created by Clément Martin on 14/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase
import FirebaseStorage
import FirebaseAuth

class ProfilGestion {
    
    
    //private var firebaseManagerData = ManagerFirebase(dataManager: DataManagerProtocol())
    private var firebaseServiceSession = FirebaseService(dataManager: ManagerFirebase())
    
    init(firebaseServiceSession: FirebaseService) {
        self.firebaseServiceSession = firebaseServiceSession
    }
    
    //var firebaseService = FirebaseService(dataManager: ManagerFirebase())
   // var manageFireBase = ManagerFirebase(dataManager: DataManagerProtocol)
    
    var idUser: String! /*CurrentUserManager.shared.user.id*//*UserDefaults.standard.string(forKey: "userID")*/
    var arrayProfil = [ProfilUser]()
    var profil: ProfilUser!
    var announceDetail: Announce!
    var arrayProfilAnnounce = [Announce]()
    var documentID = String()
    var postalCode = String()
    var city = String()
    var lat: Double!
    var long: Double!
    var imageProfil = UIImage()
    var lastConnexion: Date!
    
}

extension ProfilGestion {
    // MARK: - Announce
    func retrieveAnnounceUser(field: String, equal: String, completionHandler: @escaping (Error?, [Announce]?) -> Void) {
        firebaseServiceSession.dataManager.retrieveAnnounceUser(field: field, equal: equal) { [weak self] (error, announce) in
            guard let self = self else { return }
            guard error == nil else { completionHandler(error,nil); return }
            guard let announceSecure = announce else { return }
            self.arrayProfilAnnounce = announceSecure
            completionHandler(nil,announceSecure)
        }
    }
    //MARK: - Profil
    func retrieveProfilUser(field: String, equal: String, completionHandler: @escaping(Error?) -> Void) {
        CurrentUserManager.shared.profil = nil
        firebaseServiceSession.dataManager.retrieveProfilUser(field: field, equal: equal) { (error, profilUser) in
            guard error == nil else { completionHandler(error); return }
            guard let profilArray = profilUser else { completionHandler(error); return }
            CurrentUserManager.shared.addProfil(profilUser: profilArray[0])
            completionHandler(nil)
        }
    }
    func retrieveProfilAnnounce(field: String, equal: String, completionHandler: @escaping(Error?,[ProfilUser]?) -> Void) {
        firebaseServiceSession.dataManager.retrieveProfilUser(field: field, equal: equal) { [weak self] (error, profilUser) in
            guard let self = self else { return }
            guard error == nil else { completionHandler(error,nil); return }
            guard let profilArray = profilUser else { completionHandler(error,nil); return }
            self.profil = profilArray[0]
            completionHandler(nil,profilArray)
        }
    }
    
    func addDataProfil(profil: ProfilUser, completionHandler: @escaping(Bool?) -> Void) {
        firebaseServiceSession.dataManager.addDataProfil(profil: profil) { (bool) in
            if bool == false {
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        }
    }

    func updateProfil(documentID: String, update: [String : Any], completionHandler: @escaping(Bool) -> Void) {
        firebaseServiceSession.dataManager.updateDataProfil(documentID: documentID, update: update) { (error, bool) in
            guard error == nil else { completionHandler(false); return }
            guard let boolSecure = bool else { return }
            completionHandler(boolSecure)
        }
    }
    //MARK: - PhotoProfil
    func uploadPhotoProfil(imageData: Data, completionHandler: @escaping(Error?,StorageMetadata?) -> Void) {
        firebaseServiceSession.dataManager.uploadProfileImage(imageData: imageData) { (error, data) in
            guard error == nil else { completionHandler(error,nil); return }
            guard let image = data else { return }
            completionHandler(nil,image)
        }
    }
    //MARK: - Helpers
    func transformeDateInString() -> String {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: lastConnexion) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        guard let dateSecure = yourDate else { return "erreur" }
        let myStringafd = formatter.string(from: dateSecure)
        return myStringafd
    }

    
}
