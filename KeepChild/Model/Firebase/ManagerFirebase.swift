//
//  ManageFirebase2.swift
//  KeepChild
//
//  Created by Clément Martin on 11/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase
import FirebaseFirestore
import FirebaseAuth

class ManagerFirebase {
    //MARK: - Properties
    private let db = Firestore.firestore()
    private let dbStore = Storage.storage()
    private var announcesCollection: CollectionReference {
        return db.collection("Announce2")
    }
    private var profilsCollection: CollectionReference {
        return db.collection("ProfilUser")
    }
    private var photoProfilCollection: StorageReference {
        return dbStore.reference().child("usersProfil")
    }
    private var conversationCollection: CollectionReference {
        return db.collection("Conversation")
    }
    private var queryAnnounce: Query {
        return db.collection("Announce2")
    }
    private var queryConversation: Query {
        return db.collection("Conversation")
    }
    private var queryProfil: Query {
        return db.collection("ProfilUser")
    }
    
    private func getErrorMessage(from error: Error) -> String {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            switch errorCode {
            case .invalidEmail:
                return NSLocalizedString("invalid email", comment: "")
            case .emailAlreadyInUse:
                return NSLocalizedString("email already in use", comment: "")
            case .userNotFound:
                return NSLocalizedString("user not found", comment: "")
            case .networkError:
                return NSLocalizedString("network error", comment: "")
            case .wrongPassword:
                return NSLocalizedString("wrong password", comment: "")
            default:
                return "Error \(errorCode.rawValue): \(error.localizedDescription)"
            }
        }
        return "unknown error"
    }
}

extension ManagerFirebase: DataManagerProtocol {
    //MARK: - Account
    func signIn(withEmail email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            guard error == nil else {
                completion(false)
                return
            }
            guard let user = result?.user else { return }
            guard let email = user.email else { return }
            CurrentUserManager.shared.addUser(senderId: user.uid, mail: email)
            completion(true)
        }
    }
    
    func signOut(completionHandler: @escaping(Bool) -> Void) {
        CurrentUserManager.shared.removeUserAndProfilWhenLogOut()
        do {
            try Auth.auth().signOut()
            completionHandler(true)
        }
        catch {
            print(error.localizedDescription)
            completionHandler(false)
        }
    }
    
    func retrieveUserAuth(completionHandler: @escaping (Bool) -> Void) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            guard user != nil else {
                completionHandler(false)
                return
            }
            guard let id = user?.uid else { return }
            guard let email = user?.email else { return }
            //create user in singleton for use in app
            let user = User(senderId: id, email: email)
            CurrentUserManager.shared.user = user
            completionHandler(true)
        }
    }
    
    func resetPassword(withEmail email: String, completion: @escaping (String?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(self.getErrorMessage(from: error))
            } else {
                completion(nil)
            }
        }
    }
    
    func createAccount(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            guard error == nil else {
                completion(false)
                return
            }
            guard let user = result else { return }
            guard let email = user.user.email else { return }
            
            CurrentUserManager.shared.addUser(senderId: user.user.uid, mail: email)
            completion(true)
        }
    }
    //MARK: - Announce
    func retrieveAnnounceUser(field: String, equal: String, completionHandler: @escaping (Error?, [Announce]?) -> Void) {
        var announceProfil = [Announce]()
        queryAnnounce.whereField(field,isEqualTo: equal).getDocuments() { (querySnapshot, error) in
            guard error == nil else {
                completionHandler(error, nil)
                return
            }
            guard let querySnap = querySnapshot else { return }
            print(querySnap)
            print(querySnap.description)
            print(querySnap.debugDescription)
            for document in querySnap.documents {
                var announce = try! FirestoreDecoder().decode(Announce.self, from: document.data())
                announce.id = document.documentID
                print("\(document.documentID) => \(document.data())")
                announceProfil.append(announce)
            }
            completionHandler(nil,announceProfil)
        }
    }
    
    func deleteAnnounce(announceId: String, completionHandler: @escaping (Error?) -> Void) {
        announcesCollection.document(announceId).delete() { error in
            if let error = error {
                completionHandler(error)
            } else {
                completionHandler(nil)
                print("delete Ok")
                
            }
        }
    }
    
    func readDataAnnounce(completionHandler: @escaping (Error?, [Announce]?) -> Void) {
        var announceListArray = [Announce]()
        queryAnnounce.getDocuments { (querySnapshot, error) in
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
    
    func searchAnnounceWithFilter(lesserGeopoint: GeoPoint, greaterGeopoint: GeoPoint, completionHandler: @escaping (Error?, [Announce]?) -> Void) {
        var announceListArray = [Announce]()
        //let refFilter = test(filter: ["semaine.lundi":true])
        queryAnnounce.whereField("coordinate", isGreaterThan: lesserGeopoint).whereField("coordinate", isLessThan: greaterGeopoint).getDocuments { (querySnapshot, error) in
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
    
    func addAnnounce(announce: Announce, completionHandler: @escaping (Bool?) -> Void) {
        let docData = try! FirestoreEncoder().encode(announce)
        announcesCollection.addDocument(data: docData) {  error in
            if let error = error {
                completionHandler(false)
                print("Error writing document: \(error)")
            } else {
                completionHandler(true)
                print("Document successfully written!")
            }
        }
    }
    //MARK: - Conversation
    func addConversation(conversation: Conversation, documentID: String, completionHandler: @escaping (Bool) -> Void) {
        conversationCollection.document(documentID).setData(conversation.representation)
        completionHandler(true)
    }
    
    func updateConversation(update: [String : Any],id: String, completionHandler: @escaping (Bool) -> Void) {
        conversationCollection.document(id).updateData(update) { (error) in
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                completionHandler(false)
                return
            }
            completionHandler(true)
        }
    }
    
    func addMessageInConversation(documentID: String,arrayMessageRep: [[String: Any]], completionHandler: @escaping (Bool) -> Void) {
        conversationCollection.document(documentID).updateData(["message" : FieldValue.arrayUnion(arrayMessageRep)])
        completionHandler(true)
    }
    
    func retrieveConversationUser(field: String, completionHandler: @escaping (Error?, [Conversation]?) -> Void) {
        let idUser = CurrentUserManager.shared.user.senderId
        var arrayConversation = [Conversation]()
        queryConversation.whereField(field, isEqualTo: idUser).getDocuments { (querySnapshot, error) in
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
    
    func readConversation(documentID: String, completionHandler: @escaping (Bool?) -> Void) {
        conversationCollection.document(documentID).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                completionHandler(false)
                return
            }
            guard let doc = document.data() else {
                print("Document data was empty.")
                completionHandler(false)
                return
            }
            completionHandler(true)
            print("Current data: \(doc)")
        }
    }
    //MARK: - Profil
    func retrieveProfilUser(field: String, equal: String, completionHandler: @escaping (Error?, [ProfilUser]?) -> Void) {
        var arrayProfil = [ProfilUser]()
        queryProfil.whereField(field, isEqualTo: equal).getDocuments { (querySnapshot, error) in
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
    
    func addDataProfil(profil: ProfilUser, completionHandler: @escaping (Bool?) -> Void) {
        let docData = try! FirestoreEncoder().encode(profil)
        print(docData)
        profilsCollection.addDocument(data: docData) { error in
            if let error = error {
                print("Error writing document: \(error)")
                completionHandler(false)
            } else {
                print("Document successfully written!")
                completionHandler(true)
            }
        }
    }
    
    func updateDataProfil(documentID: String, update: [String : Any], completionHandler: @escaping (Error?, Bool?) -> Void) {
        let docRef = profilsCollection.document(documentID)
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
    //MARK: - PhotoProfil
    func uploadProfileImage(imageData: Data, completionHandler: @escaping (Error?, StorageMetadata?) -> Void) {
        let idUser = CurrentUserManager.shared.user.senderId
        let fileName = ("\(idUser).jpg")
        let profilRef = photoProfilCollection.child(fileName)
        
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
    
    func downloadPhotoProfil(idUserImage: String, completionHandler: @escaping (Error?, Data?) -> Void) {
        let photoUser = photoProfilCollection.child("\(idUserImage).jpg")
        photoUser.getData(maxSize: 1*1024*1024) { (data, error) in
            guard error == nil else { print("error download"); completionHandler(error,nil) ; return }
            guard let dataSecure = data else {
                completionHandler(nil,nil)
                return }
            // guard let image = UIImage(data: dataSecure) else { return }
            completionHandler(nil,dataSecure)
        }
    }
}
