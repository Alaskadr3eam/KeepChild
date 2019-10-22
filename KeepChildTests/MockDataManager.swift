//
//  MockDataManager.swift
//  KeepChildTests
//
//  Created by Clément Martin on 14/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase
import MessageKit

@testable import KeepChild

enum ErrorMock: Error, Equatable {
    case error
}

class MockDataManager: DataManagerProtocol {
   
    var shouldSucceed: Bool
    
   /* enum ErrorMock: Error {
        case error
    }*/
    
    init(shouldSucceed: Bool = true) {
        self.shouldSucceed = shouldSucceed
    }

    //MARK: - Account
    func retrieveUserAuth(completionHandler: @escaping (Bool) -> Void) {
        if shouldSucceed {
            CurrentUserManager.shared.user = user1
            completionHandler(true)
        } else {
            completionHandler(false)
        }
    }
    
    func signIn(withEmail email: String, password: String, completion: @escaping (Bool) -> Void) {
        if shouldSucceed {
            CurrentUserManager.shared.user = user1
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func signOut(completionHandler: @escaping (Bool) -> Void) {
        if shouldSucceed {
            CurrentUserManager.shared.user = nil
            completionHandler(true)
        } else {
            completionHandler(false)
        }
    }
    
    func resetPassword(withEmail email: String, completion: @escaping (String?) -> Void) {
        if shouldSucceed {
        } else {
        }
    }
    
    func createAccount(email: String, password: String, completion: @escaping (Bool) -> Void) {
        if shouldSucceed {
            CurrentUserManager.shared.user = user1
            completion(true)
        } else {
            completion(false)
        }
    }
    
    //MARK: - Announce
    
    func retrieveAnnounceUser(field: String, equal: String, completionHandler: @escaping (Error?, [Announce]?) -> Void) {
        if shouldSucceed {
            completionHandler(nil, [announce1])
        } else {
            completionHandler(ErrorMock.error, [])
        }
    }
    
    func deleteAnnounce(announceId: String, completionHandler: @escaping (Error?) -> Void) {
        if shouldSucceed {
            completionHandler(nil)
        } else {
            completionHandler(ErrorMock.error)
        }
    }
    
    func readDataAnnounce(completionHandler: @escaping (Error?, [Announce]?) -> Void) {
        if shouldSucceed {
            completionHandler(nil,[announce1,announce2])
        } else {
            completionHandler(ErrorMock.error, [])
        }
    }
    
    func searchAnnounceWithFilter(lesserGeopoint: GeoPoint, greaterGeopoint: GeoPoint, completionHandler: @escaping (Error?, [Announce]?) -> Void) {
        if shouldSucceed {
            completionHandler(nil,[announce1, announce2])
        } else {
            completionHandler(ErrorMock.error, [])
        }
    }
    
    func addAnnounce(announce: Announce, completionHandler: @escaping (Bool?) -> Void) {
        if shouldSucceed {
            completionHandler(true)
        } else {
            completionHandler(false)
        }
    }
    
    //MARK: - Conversation
    
    func retrieveConversationUser(field: String, completionHandler: @escaping (Error?, [Conversation]?) -> Void) {
        if shouldSucceed {
            completionHandler(nil,[conversation1])
        } else {
            completionHandler(ErrorMock.error,nil)
        }
    
    }
    
    func readConversation(documentID: String, completionHandler: @escaping (Bool?) -> Void) {
        if shouldSucceed {
            completionHandler(true)
        } else {
            completionHandler(false)
        }
    }
    
    func addConversation(conversation: Conversation, documentID: String, completionHandler: @escaping (Bool) -> Void) {
        if shouldSucceed {
            completionHandler(true)
        } else {
            completionHandler(false)
        }
    }
    
    func updateConversation(update: [String : Any], id: String, completionHandler: @escaping (Bool) -> Void) {
        if shouldSucceed {
            completionHandler(true)
        } else {
            completionHandler(false)
        }
    }
    
    func addMessageInConversation(documentID: String, arrayMessageRep: [[String : Any]], completionHandler: @escaping (Bool) -> Void) {
        if shouldSucceed {
            completionHandler(true)
        } else {
            completionHandler(false)
        }
    }
    
    //MARK: - Profil
    
    
    func retrieveProfilUser(field: String, equal: String, completionHandler: @escaping (Error?, [ProfilUser]?) -> Void) {
        if shouldSucceed {
            completionHandler(nil, [profil1])
        } else {
            completionHandler(ErrorMock.error, [])
        }
    }
    
    func addDataProfil(profil: ProfilUser, completionHandler: @escaping (Bool?) -> Void) {
        if shouldSucceed {
            completionHandler(true)
        } else {
            completionHandler(false)
        }
    }

    func updateDataProfil(documentID: String, update: [String : Any], completionHandler: @escaping (Error?, Bool?) -> Void) {
        if shouldSucceed {
            completionHandler(nil,true)
        } else {
            completionHandler(ErrorMock.error,false)
        }
    }
    
    //MARK: - PhotoProfil
    
    func uploadProfileImage(imageData: Data, completionHandler: @escaping (Error?, StorageMetadata?) -> Void) {
        let metadata = StorageMetadata()
        if shouldSucceed {
            completionHandler(nil,metadata)
        } else {
            completionHandler(ErrorMock.error,nil)
        }
    }
    
    func downloadPhotoProfil(idUserImage: String, completionHandler: @escaping (Error?, Data?) -> Void) {  }
    
    
    
    
}

/*private class MockDatabaseReference: CollectionReference {
    
    override func whereField(_ field: String, isEqualTo value: Any) -> Query {
        return self
    }
    
    override func getDocuments(completion: @escaping FIRQuerySnapshotBlock) {
        let querySnapshot = MockQuerySnapshot()
        DispatchQueue.global().async {
            block(querySnapshot)
        }
    }
}

class MockQuerySnapshot: QuerySnapshot {
   
    let announce1Query = try! FirestoreEncoder().encode(announce1)
    let announce2Query = try! FirestoreEncoder().encode(announce2)
  
    override var documents: [MockQueryDocumentSnapshot]? {
        return [announce1Query,announce2Query]
    }
    
  
    
}

class MockQueryDocumentSnapshot: QueryDocumentSnapshot {
    
    let announce1Query = try! FirestoreEncoder().encode(announce1)
    
    override func data() -> [String : Any] {
        return announce1Query
    }
}*/
