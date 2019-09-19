//
//  AnnounceList.swift
//  KeepChild
//
//  Created by Clément Martin on 13/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

class AnnounceList {
    
    //var delegateAnnounceList: AnnounceListDelegate?
    
    //var announceReference: DocumentReference?
    
    var manageFireBase = ManageFireBase()
    
  /*  fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
               // observeQuery()
            }
        }
    }*/
    
    //private var listener: ListenerRegistration?
    //var documents: [DocumentSnapshot] = []
    //var didChangeData: ((AnnounceListData) -> Void)?
    var announceDetail: Announce!
    var announceList = [Announce]()
    var idUser = UserDefaults.standard.string(forKey: "userID")
   /* var viewData: AnnounceListData {
        didSet {
            didChangeData?(viewData)
        }
    }*/
    
   /* init(viewData: AnnounceListData) {
        self.viewData = viewData
        query = baseQuery()
    }*/
    func readData(collection: String, completionHandler: @escaping (Error?,[Announce]?) -> Void) {
        manageFireBase.readDataAnnounce(collection: collection) { [weak self] (error, announceList) in
            guard let self = self else { return }
            guard error == nil else {
                completionHandler(error,nil)
                return
            }
            guard let announce = announceList else { return }
            self.announceList = announce
            completionHandler(nil,announce)
        }
    }
    
   /* func addData(announce: Announce) {
        manageFireBase.addData(announce: announce)
    }*/

    /*func addData(announce: Announce) {
        let docData = try! FirestoreEncoder().encode(announce)
        Firestore.firestore().collection("Announce2").addDocument(data: docData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }*/
   /* func observeQuery() {
      /*  guard let query = query else { return }
        stopObserving()
        
        listener = query.addSnapshotListener { (snapshot, error) in
            
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
        */
        
            Firestore.firestore().collection("Announce").getDocuments { (document, error) in
                if let document = document {
                    let model = try! FirestoreDecoder().decode(Announce.self, from: document)
                    print(model)
                    self.announceListData = [model]
                } else {
                    print("document no exist")
                }
            }
            
          //  self.documents = snapshot.documents
            
        //}
    }*/
    
    /*func stopObserving() {
        listener?.remove()
    }*/
    
/*    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection("Announce").limit(to: 50)
    }*/
    
    
    
}
/*protocol AnnounceListDelegate {
    func updateTableView()
}*/
