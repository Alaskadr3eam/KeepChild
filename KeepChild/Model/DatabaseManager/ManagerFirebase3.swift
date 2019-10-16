//
//  ManagerFirebase3.swift
//  KeepChild
//
//  Created by Clément Martin on 15/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

/*import Foundation
import CodableFirebase
import Firebase

class ManagerFirebase3 {
    
    private let collectionReference: CollectionReference
    

    init(with collectionReference: CollectionReference) {
        self.collectionReference = collectionReference
    }
    
    func retrieveAnnounceUser(field: String, equal: String, completionHandler: @escaping (Error?, [Announce]?) -> Void) {
        var announceProfil = [Announce]()
        self.collectionReference.path = "Announce2"
        self.collectionReference.whereField(field,isEqualTo: equal).getDocuments() { (querySnapshot, error) in
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
 
}*/

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
    
    override var documents: [QueryDocumentSnapshot]? {
        return []
    }
}*/
