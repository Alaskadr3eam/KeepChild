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
    
   // var manageFireBase = ManageFireBase()
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
    
}
extension ProfilGestion {
    // MARK: - Announce
    func retrieveAnnounceUser(field: String, equal: String, completionHandler: @escaping (Error?, [Announce]?) -> Void) {
        DependencyInjection.shared.dataManager.retrieveAnnounceUser(field: field, equal: equal) { [weak self] (error, announce) in
            guard let self = self else { return }
            guard error == nil else { completionHandler(error,nil); return }
            guard let announceSecure = announce else { return }
            self.arrayProfilAnnounce = announceSecure
            completionHandler(nil,announceSecure)
        }
    }
    //MARK: - Profil
    func retrieveProfilAnnounce(field: String, equal: String, completionHandler: @escaping(Error?,[ProfilUser]?) -> Void) {
        DependencyInjection.shared.dataManager.retrieveProfilUser(field: field, equal: equal) { [weak self] (error, profilUser) in
            guard let self = self else { return }
            guard error == nil else { completionHandler(error,nil); return }
            guard let profilArray = profilUser else {
                completionHandler(error,nil)
                return }
            self.profil = profilArray[0]
            completionHandler(nil,profilArray)
        }
    }
    
    func addDataProfil(profil: ProfilUser, completionHandler: @escaping(Bool?) -> Void) {
        DependencyInjection.shared.dataManager.addDataProfil(profil: profil) { (bool) in
            if bool == false {
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        }
    }

    func updateProfil(documentID: String, update: [String : Any], completionHandler: @escaping(Error?, Bool?) -> Void) {
        DependencyInjection.shared.dataManager.updateDataProfil(documentID: documentID, update: update) { (error, bool) in
            guard error == nil else { completionHandler(error,nil); return }
            guard let boolSecure = bool else { return }
            completionHandler(nil,boolSecure)
        }
    }
    //MARK: - PhotoProfil
    func uploadPhotoProfil(imageData: Data, completionHandler: @escaping(Error?,StorageMetadata?) -> Void) {
        DependencyInjection.shared.dataManager.uploadProfileImage(imageData: imageData) { (error, data) in
            guard error == nil else { completionHandler(error,nil); return }
            guard let image = data else { return }
            completionHandler(nil,image)
        }
    }

    func downloadPhotoProfil(idUserImage: String, completionHandler: @escaping (Error?,Data?) -> Void) {
        DependencyInjection.shared.dataManager.downloadPhotoProfil(idUserImage: idUserImage) { (error, data) in
            guard error == nil else { completionHandler(error,nil); return }
            guard let dataSecure = data else { return }
            completionHandler(nil,dataSecure)
        }
    }
    
    
    
    
    
    func uploadProfileImage(imageData: Data)
    {
        /*let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)*/
        
        
        let storageReference = Storage.storage().reference()
        let currentUser = Auth.auth().currentUser
        let profileImageRef = storageReference.child("users").child(currentUser!.uid).child("\(currentUser!.uid)-profileImage.jpg")
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        profileImageRef.putData(imageData, metadata: uploadMetaData) { (uploadedImageMeta, error) in
            
          // activityIndicator.stopAnimating()
           // activityIndicator.removeFromSuperview()
            
            if error != nil
            {
                print("Error took place \(String(describing: error?.localizedDescription))")
                return
            } else {
                
            //self.userProfileImageView.image = UIImage(data: imageData)
                
                print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
            }
        }
    }
    
 /*   func transformUIimageInData(image: UIImageView) {
        let pictureSave = image.image?.pngData()
    }
    
    func downloadPhoto() {
        
    }*/
    
}


   

/*
 func retrieveAnnounceUser(collection: String, field: String, equal: String, completionHandler: @escaping (Error?, [Announce]?) -> Void) {
 
 manageFireBase.retrieveAnnounceUser(collection: collection, field: field, equal: equal) { [weak self] (error, announce) in
 guard let self = self else { return }
 guard error == nil else { completionHandler(error,nil); return }
 guard let announceSecure = announce else { return }
 self.arrayProfilAnnounce = announceSecure
 completionHandler(nil,announceSecure)
 }
 }
 
 func retrieveProfilAnnounce(collection: String, field: String, equal: String, completionHandler: @escaping(Error?,[ProfilUser]?) -> Void) {
 manageFireBase.retrieveProfilUser(collection: collection, field: field, equal: equal) { [weak self] (error, profilUser) in
 
 guard let self = self else { return }
 guard error == nil else { completionHandler(error,nil); return }
 guard let profilArray = profilUser else {
 completionHandler(error,nil)
 return }
 self.profil = profilArray[0]
 completionHandler(nil,profilArray)
 }
 }
 
 func uploadPhotoProfil(imageData: Data, completionHandler: @escaping(Error?,StorageMetadata?) -> Void) {
 manageFireBase.uploadProfileImage(imageData: imageData) { (error, data) in
 guard error == nil else { completionHandler(error,nil); return }
 guard let image = data else { return }
 completionHandler(nil,image)
 }
 }
 
 func downloadPhotoProfil(idUserImage: String, completionHandler: @escaping (Error?,Data?) -> Void) {
 manageFireBase.downloadPhotoProfil(idUserImage: idUserImage) { (error, data) in
 guard error == nil else { completionHandler(error,nil); return }
 guard let dataSecure = data else { return }
 completionHandler(nil,dataSecure)
 }
 }
 
 func addDataProfil(profil: ProfilUser) {
 manageFireBase.addDataProfil(profil: profil)
 }
 
 func updateProfil(collection: String, documentID: String, update: [String : Any], completionHandler: @escaping(Error?, Bool?) -> Void) {
 manageFireBase.updateData(collection: collection, documentID: documentID, update: update) { (error, bool) in
 guard error == nil else { completionHandler(error,nil); return }
 guard let boolSecure = bool else { return }
 completionHandler(nil,boolSecure)
 }
 }
 
 func uploadProfileImage(imageData: Data)
 {
 /*let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
 activityIndicator.startAnimating()
 activityIndicator.center = self.view.center
 self.view.addSubview(activityIndicator)*/
 
 
 let storageReference = Storage.storage().reference()
 let currentUser = Auth.auth().currentUser
 let profileImageRef = storageReference.child("users").child(currentUser!.uid).child("\(currentUser!.uid)-profileImage.jpg")
 
 let uploadMetaData = StorageMetadata()
 uploadMetaData.contentType = "image/jpeg"
 
 profileImageRef.putData(imageData, metadata: uploadMetaData) { (uploadedImageMeta, error) in
 
 // activityIndicator.stopAnimating()
 // activityIndicator.removeFromSuperview()
 
 if error != nil
 {
 print("Error took place \(String(describing: error?.localizedDescription))")
 return
 } else {
 
 //self.userProfileImageView.image = UIImage(data: imageData)
 
 print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
 }
 }
 }
 
 /*   func transformUIimageInData(image: UIImageView) {
 let pictureSave = image.image?.pngData()
 }
 
 func downloadPhoto() {
 
 }*/
 
 }
 */
 
 
 
 

