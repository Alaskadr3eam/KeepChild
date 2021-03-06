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
    
    var delegateProfilGestion: ProfilGestionDelegate?
    let storage = Storage.storage()
    //let storage = Storage.reference(forURL: "gs://keepchild-7145f.appspot.com/PictureProfil")
    var idUser = String()
    var arrayProfil = [ProfilUser]()
    var profil: ProfilUser!
    var arrayProfilAnnounce = [Announce]()
    var imageProfil = UIImage()
    
    
    
   
    
    func retrieveProfilUser(idUser: String) {
        let idUserAnnouce = idUser
        Firestore.firestore().collection("ProfilUser").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("erreur : \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let profil = try! FirestoreDecoder().decode(ProfilUser.self, from: document.data())
                    self.arrayProfil.append(profil)
                    print(document.documentID, document.data())
                    
                }
                for profil in self.arrayProfil {
                    if profil.iDuser == idUserAnnouce {
                        self.profil = profil
                    }
                }
                self.delegateProfilGestion?.initViewDetailAnnounce()
                self.delegateProfilGestion?.initViewEditProfil()
            }
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

    
    func addPhoto(image: UIImage) {
        let pictureSave = image.pngData()
        let storageRef = storage.reference()
        let photoProfil = storageRef.child("PictureProfil/")
        let data = pictureSave
        _ = photoProfil.putData(data!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print("error")
                return
            }
            _ = metadata.size
            photoProfil.downloadURL { (url, error) in
                guard url != nil else {
                    print("error url")
                    return
                }
            }
        }

    }
    
    func transformUIimageInData(image: UIImageView) {
        let pictureSave = image.image?.pngData()
    }
    
    func downloadPhoto() {
        
    }
    
}
protocol ProfilGestionDelegate {
    func initViewDetailAnnounce()
    func initViewEditProfil()
}
