//
//  ManageFireBAse.swift
//  KeepChild
//
//  Created by Clément Martin on 18/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

class ManageFireBase {
    
    //var arrayProfilAnnounce = [Announce]()
    //var profilRetrieve: ProfilUser!
    
    //var queryAnnounceProfil: Query!
    //var queryProfil: Query!
    //var idUser = String()
    //var profil: ProfilUser!
    //var announceProfil = [Announce]()
    
    //var queryAnnounceAll: Query!
    //var announceListData = [Announce]()
    
    //for detail announce
    //var announceDetail: Announce!

    
    
    func createQuery(collection: String, field: String, equal: String) -> Query {
        let query = Firestore.firestore().collection(collection).whereField(field, isEqualTo: equal)
       
        return query
    }

    func createQueryAll(collection: String) -> Query {
        let query = Firestore.firestore().collection(collection)
        return query
    }
    
    func retrieveIdUserConnected(completion: @escaping(Error?, String?) -> Void) {
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                guard let id = user?.uid else { return }
                completion(nil,id)
            }
        }
        
    }

    func retrieveAnnounceUser(collection: String, field: String, equal: String,completionHandler: @escaping(Error?, [Announce]?) -> Void) {
        var announceProfil = [Announce]()
        createQuery(collection: collection, field: field, equal: equal).getDocuments() { (querySnapshot, error) in
            guard error == nil else {
                completionHandler(error, nil)
                return
            }
            guard let querySnap = querySnapshot else { return }
                for document in querySnap.documents {
                    var announce = try! FirestoreDecoder().decode(Announce.self, from: document.data())
                    announce.id = document.documentID
                    print("\(document.documentID) => \(document.data())")
                    announceProfil.append(announce)
                }
                completionHandler(nil,announceProfil)
            }
    }
    
    func deleteAnnounce(announceId: String) {
        Firestore.firestore().collection("Announce2").document(announceId).delete() { err in
            if let err = err {
                print("error")
            } else {
                print("delete Ok")
                
                }
            }
    }
    
    func retrieveConversationUser(field: String, completionHandler: @escaping(Error?,[Conversation]?) -> Void) {
        var arrayConversation = [Conversation]()
        
        createQuery(collection: "Conversation", field: field, equal: CurrentUserManager.shared.user.senderId).getDocuments { (querySnapshot, error) in
            guard error == nil else {
                completionHandler(error, nil)
                return
            }
            
            guard let querySnap = querySnapshot else { return }
            for document in querySnap.documents {
                let doc = document.data()
                let name = doc["name"] as! String
                let idUser1 = doc["idUser1"] as! String
                let idUser2 = doc["idUser2"] as! String
                let arrayMessage = doc["message"] as! [[String : Any]]
                let conversation = Conversation(id: document.documentID, name: name, idUser1: idUser1, idUser2: idUser2, arrayMessage: arrayMessage)
                arrayConversation.append(conversation)
            }
            if arrayConversation.count == 0 {
                completionHandler(nil,nil)
            } else {
                completionHandler(nil,arrayConversation)
            }
        }
    }

    func retrieveProfilUser(collection: String, field: String, equal: String, completionHandler: @escaping(Error?,[ProfilUser]?) -> Void) {
        var arrayProfil = [ProfilUser]()
        
        createQuery(collection: collection, field: field, equal: equal).getDocuments { (querySnapshot, error) in
            guard error == nil else {
                completionHandler(error, nil)
                return
            }
            
            guard let querySnap = querySnapshot else { return }
                for document in querySnap.documents {
                    var profil = try! FirestoreDecoder().decode(ProfilUser.self, from: document.data())
                    profil.id = document.documentID
                    arrayProfil.append(profil)
                    print(document.documentID, document.data())
                }
                if arrayProfil.count == 0 {
                    completionHandler(nil,nil)
                } else {
                    completionHandler(nil,arrayProfil)
                }
            }
    }
    
    func updateData(collection: String, documentID: String, update: [String:Any], completionHandler: @escaping(Error?,Bool?) -> Void) {
        let ref = Firestore.firestore().collection(collection)
        let docRef = ref.document(documentID)
        
        docRef.updateData(update) { err in
            guard err == nil else {
                print("error update")
                completionHandler(err,false)
                return
            }
            print("update success")
            completionHandler(nil,true)
        }
    }
    
    func readDataAnnounce(collection: String, completionHandler: @escaping (Error?,[Announce]?) -> Void) {
        var announceListArray = [Announce]()
        createQueryAll(collection: collection).getDocuments { (querySnapshot, error) in
            guard error == nil else {
                completionHandler(error, nil)
                return
            }
            guard let querySnap = querySnapshot else { return }
                for document in querySnap.documents {
                    print(document.data())
                    
                    var announce = try! FirestoreDecoder().decode(Announce.self, from: document.data())
                    announce.id = document.documentID
                    announceListArray.append(announce)
                    print(document.documentID, document.data())
                }
            completionHandler(nil,announceListArray)
            }
            //self.delegateManageFireBaseAnnounceSearch?.resultForRequestAnnounceSearch()
    }

    func searchAnnounceWithFilter(dayFilter: [String], completionHandler: @escaping (Error?,[Announce]?) -> Void) {
        var announceListArray = [Announce]()
        Firestore.firestore().collection("Announce2").whereField("dayList", arrayContains: dayFilter[0]).getDocuments { (querySnapshot, error) in
            guard error == nil else {
                completionHandler(error, nil)
                return
            }
            guard let querySnap = querySnapshot else { return }
            for document in querySnap.documents {
                print(document.data())
                
                var announce = try! FirestoreDecoder().decode(Announce.self, from: document.data())
                announce.id = document.documentID
                announceListArray.append(announce)
                print(document.documentID, document.data())
            }
            completionHandler(nil,announceListArray)
        }
        
    }

    func searchAnnounceWithFilter(dayFilter: String, boolFilter: Bool, completionHandler: @escaping (Error?,[Announce]?) -> Void) {
        var announceListArray = [Announce]()
        Firestore.firestore().collection("Announce2").whereField(dayFilter, isEqualTo: boolFilter).getDocuments { (querySnapshot, error) in
            guard error == nil else {
                completionHandler(error, nil)
                return
            }
            guard let querySnap = querySnapshot else { return }
            for document in querySnap.documents {
                print(document.data())
                
                var announce = try! FirestoreDecoder().decode(Announce.self, from: document.data())
                announce.id = document.documentID
                announceListArray.append(announce)
                print(document.documentID, document.data())
            }
            completionHandler(nil,announceListArray)
        }
        
    }

    
    
    func addData(announce: Announce) {
        let docData = try! FirestoreEncoder().encode(announce)
        print(docData)
        Firestore.firestore().collection("Announce2").addDocument(data: docData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }

    func addDataProfil(profil: ProfilUser) {
        let docData = try! FirestoreEncoder().encode(profil)
        print(docData)
        Firestore.firestore().collection("ProfilUser").addDocument(data: docData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }

    func addDataSemaine(semaine: Semaine, idDocument: String) {
        let docData = try! FirestoreEncoder().encode(semaine)
        print(docData)
        Firestore.firestore().collection("Semaine").document(idDocument).setData(docData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }

    func uploadProfileImage(imageData: Data, completionHandler: @escaping (Error?,StorageMetadata?) -> Void) {
        /*let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
         activityIndicator.startAnimating()
         activityIndicator.center = self.view.center
         self.view.addSubview(activityIndicator)*/
        
        
        let storageReference = Storage.storage().reference()
        let currentUser = Auth.auth().currentUser
        let profileImageRef = storageReference.child("usersProfil")/*.child(currentUser!.uid).child("\(currentUser!.uid)-profileImage.jpg")*/
        let fileName = ("\(currentUser!.uid).jpg")
        let profilRef = profileImageRef.child(fileName)
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        profilRef.putData(imageData, metadata: uploadMetaData) { (uploadedImageMeta, error) in
            guard error == nil else {
                print("Error took place \(String(describing: error?.localizedDescription))")
                completionHandler(error,nil)
                return
            }
            guard let imageUpload = uploadedImageMeta else { return }
            print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
            completionHandler(nil,imageUpload)
        }
    }
    
    func downloadPhotoProfil(idUserImage: String, completionHandler: @escaping (Error?,Data?) -> Void) {
        let storageReference = Storage.storage().reference()
        let reference = storageReference.child("usersProfil")
        let photoUser = reference.child("\(idUserImage).jpg")
        photoUser.getData(maxSize: 1*1024*1024) { (data, error) in
            guard error == nil else { print("error download"); completionHandler(error,nil) ; return }
            guard let dataSecure = data else {
                completionHandler(nil,nil)
                return }
           // guard let image = UIImage(data: dataSecure) else { return }
            completionHandler(nil,dataSecure)
        }
    }
    
  /*  func retrieveAnnounceUser(idUser: String, completion: @escaping(Error?, [Announce]?) -> Void) {
        var announce2 = [Announce]()
        var arrayTampon = [Announce]()
        Firestore.firestore().collection("Announce2").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("erreur : \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let announce = try! FirestoreDecoder().decode(Announce.self, from: document.data())
                    arrayTampon.append(announce)
                    print(document.documentID, document.data())
                    
                }
                for announce in arrayTampon {
                    if announce.idUser == idUser {
                        announce2.append(announce)
                        
                    }
                }
                completion(nil,announce2)
            }
        }
    }*/
}
