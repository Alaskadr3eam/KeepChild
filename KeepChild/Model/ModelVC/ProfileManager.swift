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

class ProfileManager {
    //MARK: - Properties
    private var firebaseServiceSession = FirebaseService(dataManager: ManagerFirebase())
    
    init(firebaseServiceSession: FirebaseService) {
        self.firebaseServiceSession = firebaseServiceSession
    }
    
    var idUser: String?
    var profil: Profile?
    var announceDetail: Announce?
    var arrayProfilAnnounce = [Announce]()
    var postalCode = String()
    var city = String()
    
    var lastConnexion: Date?
    
    // MARK: - Announce
    ///feature that retrieves user-owned ads
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
    ///function that allows to find the profile of the user
    func retrieveProfilUser(field: String, equal: String, completionHandler: @escaping(Error?,Bool?) -> Void) {
        CurrentUserManager.shared.profil = nil
        firebaseServiceSession.dataManager.retrieveProfilUser(field: field, equal: equal) { (error, profilUser) in
            guard error == nil else { completionHandler(error,nil); return }
            guard let profilArray = profilUser else { completionHandler(nil,false); return }
            CurrentUserManager.shared.addProfil(profilUser: profilArray[0])
            completionHandler(nil,true)
        }
    }
    ///function that allows fo find the profile of the announce
    func retrieveProfilAnnounce(field: String, equal: String, completionHandler: @escaping(Error?,[Profile]?) -> Void) {
        firebaseServiceSession.dataManager.retrieveProfilUser(field: field, equal: equal) { [weak self] (error, profilUser) in
            guard let self = self else { return }
            guard error == nil else { completionHandler(error,nil); return }
            guard let profilArray = profilUser else { completionHandler(error,nil); return }
            self.profil = profilArray[0]
            completionHandler(nil,profilArray)
        }
    }
    ///feature that adds a profile to the database
    func addDataProfil(profil: Profile, completionHandler: @escaping(Bool?) -> Void) {
        firebaseServiceSession.dataManager.addDataProfil(profil: profil) { (bool) in
            if bool == false {
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        }
    }
    ///feature that update a profile to the database
    func updateProfil(documentID: String, update: [String : Any], completionHandler: @escaping(Bool) -> Void) {
        firebaseServiceSession.dataManager.updateDataProfil(documentID: documentID, update: update) { (error, bool) in
            guard error == nil else { completionHandler(false); return }
            guard let boolSecure = bool else { return }
            completionHandler(boolSecure)
        }
    }
    //MARK: - PhotoProfil
    ///feature that add a picture profile to the database
    func uploadPhotoProfil(imageData: Data, completionHandler: @escaping(Error?,StorageMetadata?) -> Void) {
        firebaseServiceSession.dataManager.uploadProfileImage(imageData: imageData) { (error, data) in
            guard error == nil else { completionHandler(error,nil); return }
            guard let image = data else { return }
            completionHandler(nil,image)
        }
    }
    //MARK: - Helpers
    ///function for transformate Date() in String
    func transformeDateInString() -> String? {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let dateConnexion = lastConnexion else { return nil }
        let myString = formatter.string(from: dateConnexion) // string purpose I add here
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
