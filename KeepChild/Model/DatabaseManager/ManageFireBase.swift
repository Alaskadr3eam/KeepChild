//
//  ManageFireBAse.swift
//  KeepChild
//
//  Created by Clément Martin on 18/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

/*import Foundation
import Firebase
import FirebaseFirestore
import CodableFirebase
import FirebaseAuth







class ManageFireBase {
    
 /*   var collectionAnnounce: String
    var collectionProfil: String
    var collectionConversation: String*/

    
  /*  init(collectionAnnounce: String) {
        self.collectionAnnounce = collectionAnnounce
    }*/
    
 
    
    
    func createQuery(collection: String, field: String, equal: String) -> Query {
        let query = Firestore.firestore().collection(collection).whereField(field, isEqualTo: equal)
        //let query = db.collection(collection).whereField(field, isEqualTo: equal)
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
    func readConversation(documentID: String,completionHandler: @escaping(Bool?)->Void) {
       
        Firestore.firestore().collection("Conversation").document(documentID).addSnapshotListener { documentSnapshot, error in
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
 /*   func testBoucle(completionHandler: @escaping(Error?,[Announce]?) -> Void) {
        var announceListArray = [Announce]()
        var announceListArrayCompleted = [Announce]()
        var isOK = false
        let group = DispatchGroup()
       //  group.enter()
        for (day,bool) in filter {
           
            searchAnnounceWithFilter(dayFilter: day, boolFilter: bool) { (error, announceList) in
                guard error == nil else {
                    return
                }
                guard let announceArray = announceList else { return }
                for announce in announceArray {
                    announceListArrayCompleted.append(announce)
                }
            }
        }
       //group.leave()
        
        
    }*/
    
    
    func getDocumentAnnounceNearby(lesserGeopoint: GeoPoint, greaterGeopoint: GeoPoint) {
        let docRef = Firestore.firestore().collection("locations")
        let query = docRef.whereField("location", isGreaterThan: lesserGeopoint).whereField("location", isLessThan: greaterGeopoint)
        
        query.getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        
    }

    

    func searchAnnounceWithFilter(completionHandler: @escaping (Error?,[Announce]?) -> Void) {
        var announceListArray = [Announce]()
        Firestore.firestore().collection("Announce2").whereField("semaine.jeudi", isEqualTo: true).whereField("semaine.mercredi", isEqualTo: true).getDocuments { (querySnapshot, error) in
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
    var filter = ["semaine.mercredi":true,
                  "semaine.jeudi":true]
    /*var request = Firestore.firestore().collection("Announce2").whereField("semaine.lundi", isEqualTo: true).whereField("semaine.mardi", isEqualTo: nil).whereField("semaine.mercredi", isEqualTo: nil).whereField("semaine.jeudi", isEqualTo: nil).whereField("semaine.vendredi", isEqualTo: nil).whereField("semaine.samedi", isEqualTo: nil).whereField("semaine.dimanche", isEqualTo: nil)*/
   /* func test -> CollectionReference {
        var request = Firestore.firestore().collection("Announce2").whereField("semaine.lundi", isEqualTo: true).whereField("semaine.mardi", isEqualTo: nil).whereField("semaine.mercredi", isEqualTo: nil).whereField("semaine.jeudi", isEqualTo: nil).whereField("semaine.vendredi", isEqualTo: nil).whereField("semaine.samedi", isEqualTo: nil).whereField("semaine.dimanche", isEqualTo: nil)
        for (key,value) in filter {
            request = request.whereField(key, isEqualTo: value)
        }
        return request
    }*/
    
    
    func searchAnnounceWithFilter(lesserGeopoint: GeoPoint, greaterGeopoint: GeoPoint, completionHandler: @escaping (Error?,[Announce]?) -> Void) {
        var announceListArray = [Announce]()
        //let refFilter = test(filter: ["semaine.lundi":true])
        Firestore.firestore().collection("Announce2").whereField("coordinate", isGreaterThan: lesserGeopoint).whereField("coordinate", isLessThan: greaterGeopoint).getDocuments { (querySnapshot, error) in
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

    
    
    func addData(announce: Announce, completionHandler: @escaping(Bool?) -> Void) {
        let docData = try! FirestoreEncoder().encode(announce)
        print(docData)
        Firestore.firestore().collection("Announce2").addDocument(data: docData) {  error in
            
            if let error = error {
                completionHandler(false)
                print("Error writing document: \(error)")
            } else {
                completionHandler(true)
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

*/
