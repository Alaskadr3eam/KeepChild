//
//  FirebaseProtocol.swift
//  KeepChild
//
//  Created by Clément Martin on 11/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

/*enum ErrorFirebase: Error {
    case offline
}
enum Result {
    case successAnnounce([Announce])
    case successUser(User)
    case failure(ErrorFirebase)
}*/

protocol DataManagerProtocol {
    
    //MARK: - User
    func retrieveUserAuth(completionHandler: @escaping(Bool) -> Void)
    func signIn(withEmail email: String, password: String, completion: @escaping (Bool) -> Void)
    
    func signOut(completionHandler: @escaping(Bool) -> Void)
    
    func resetPassword(withEmail email: String, completion: @escaping (String?) -> Void)
    func createAccount(email: String, password: String, completion: @escaping (Bool) -> Void)
    //MARK: - Announce
    func retrieveAnnounceUser(field: String, equal: String,completionHandler: @escaping(Error?, [Announce]?) -> Void)
    func deleteAnnounce(announceId: String, completionHandler: @escaping (Error?) -> Void)
    func readDataAnnounce(completionHandler: @escaping (Error?,[Announce]?) -> Void)
    //func searchAnnounceWithFilter(completionHandler: @escaping (Error?,[Announce]?) -> Void)
    func searchAnnounceWithFilter(lesserGeopoint: GeoPoint, greaterGeopoint: GeoPoint, completionHandler: @escaping (Error?,[Announce]?) -> Void)
    func addAnnounce(announce: Announce, completionHandler: @escaping(Bool?) -> Void)
  /*  func getDocumentAnnounceNearby(lesserGeopoint: GeoPoint, greaterGeopoint: GeoPoint)*/
    
    //MARK: - Conversation
    func retrieveConversationUser(field: String, completionHandler: @escaping(Error?,[Conversation]?) -> Void)
    func readConversation(documentID: String,completionHandler: @escaping(Bool?)->Void)
    func addConversation(conversation: Conversation, documentID: String, completionHandler: @escaping(Bool) -> Void)
    func updateConversation(update: [String:Any],id: String, completionHandler: @escaping(Bool) -> Void)
    func addMessageInConversation(documentID: String,arrayMessageRep: [[String: Any]], completionHandler: @escaping(Bool) -> Void)
    
    //MARK: - Profil
    func retrieveProfilUser(field: String, equal: String, completionHandler: @escaping(Error?,[ProfilUser]?) -> Void)
    func addDataProfil(profil: ProfilUser, completionHandler: @escaping (Bool?) -> Void)
    
    //MARK: - PhotoProfil
    func uploadProfileImage(imageData: Data, completionHandler: @escaping (Error?,StorageMetadata?) -> Void)
    func downloadPhotoProfil(idUserImage: String, completionHandler: @escaping (Error?,Data?) -> Void)
    
    //MARK: - For All
    func updateDataProfil(documentID: String, update: [String:Any], completionHandler: @escaping(Error?,Bool?) -> Void)
    

    

    

    //func addDataSemaine(semaine: Semaine, idDocument: String)

    
}
