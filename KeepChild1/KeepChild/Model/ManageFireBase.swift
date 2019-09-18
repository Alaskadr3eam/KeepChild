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
    
    var delegateManageFirebase: ManageFireBaseDelegate?
    var delegateManageFireBaseEditProfil: ManageFireBaseDelegateEditProfil?
    var delegateManageFireBaseAnnounceSearch: ManageFireBaseDelegateAnnounceSearch?
    var delegateManageFireBaseDetailAnnounce: ManageFireBaseDelegateDetailAnnounce?
    
    var arrayProfilAnnounce = [Announce]()
    var profilRetrieve: ProfilUser!
    
    var queryAnnounceProfil: Query!
    var queryProfil: Query!
    var idUser = String()
    var profil: ProfilUser!
    var announceProfil = [Announce]()
    
    var queryAnnounceAll: Query!
    var announceListData = [Announce]()
    
    //for detail announce
    var announceDetail: Announce!
    
    func createQuery(collection: String, field: String) -> Query {
        let query = Firestore.firestore().collection(collection).whereField(field, isEqualTo: idUser)
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
    
    func retrieveAnnounceUser2(/*query: Query*/) {
        var announceProfil = [Announce]()
        queryAnnounceProfil.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("error")
            } else {
                print(querySnapshot)
                for document in querySnapshot!.documents {
                    let announce = try! FirestoreDecoder().decode(Announce.self, from: document.data())
                    print("\(document.documentID) => \(document.data())")
                    announceProfil.append(announce)
                }
                self.announceProfil = announceProfil
                self.delegateManageFirebase?.resultForRequestAnnounce(announce: announceProfil)
            }
        }
    }
    
    func retrieveProfilUser(/*query: Query*/) {
        var arrayProfil = [ProfilUser]()

        queryProfil.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("erreur : \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let profil = try! FirestoreDecoder().decode(ProfilUser.self, from: document.data())
                    arrayProfil.append(profil)
                    print(document.documentID, document.data())
                }
                //self.delegateManageFirebase?.resultForRequestProfil(profilUser: arrayProfil[0])
                if arrayProfil.count == 0 {
                    
                } else {
                self.profil = arrayProfil[0]
                self.delegateManageFirebase?.resultForRequestProfil(profilUser: arrayProfil[0])
                self.delegateManageFireBaseEditProfil?.resultForRequestProfil()
                self.delegateManageFireBaseDetailAnnounce?.resultForRequestProfil()
                }
            }
        }
    }
    
    func readDataAnnounce() {
        announceListData = [Announce]()
        queryAnnounceAll.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("erreur : \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let announce = try! FirestoreDecoder().decode(Announce.self, from: document.data())
                    self.announceListData.append(announce)
                    print(document.documentID, document.data())
                }
            }
            self.delegateManageFireBaseAnnounceSearch?.resultForRequestAnnounceSearch()
        }
    }
    
    func addData(announce: Announce) {
        let docData = try! FirestoreEncoder().encode(announce)
        Firestore.firestore().collection("Announce2").addDocument(data: docData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func retrieveAnnounceUser(idUser: String, completion: @escaping(Error?, [Announce]?) -> Void) {
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
    }
}

protocol ManageFireBaseDelegate {
    func resultForRequestAnnounce(announce: [Announce])
    func resultForRequestProfil(profilUser: ProfilUser)
}

protocol ManageFireBaseDelegateEditProfil {
    func resultForRequestProfil()
}

protocol ManageFireBaseDelegateAnnounceSearch {
    func resultForRequestAnnounceSearch()
}

protocol ManageFireBaseDelegateDetailAnnounce {
    func resultForRequestProfil()
}
