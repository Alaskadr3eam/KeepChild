//
//  ManageConversation.swift
//  KeepChild
//
//  Created by Clément Martin on 10/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ConversationManager {
    
    private var firebaseServiceSession = FirebaseService(dataManager: ManagerFirebase())
    
    init(firebaseServiceSession: FirebaseService) {
        self.firebaseServiceSession = firebaseServiceSession
    }
    
    //properties for conversationVC
    var arrayConversation = [Conversation]()
    var arrayMessage = [Message]()
    var conversation: Conversation?
    var newConversation: Conversation?
    //properties for messageVC
    var messages = [Message]()
    var messageDict = [[String : Any]]()
    //properties for firstMessageVC
    var idAnnounceUser = String()
    var arrayMessageRep = [[String: Any]]()
    var announce: Announce?
    var isExisting: Bool = false
    var documentID = String()
    
    //func for conversationVC
    ///function that allows you retrive conversation of user
    func retrieveConversion(field: String, completionHandler: @escaping(Error?,Bool?) -> Void) {
        firebaseServiceSession.dataManager.retrieveConversationUser(field: field) { [weak self] (error, conversation) in
            guard let self = self else { return }
            guard error == nil else {
                completionHandler(error,nil)
                return
            }
            guard conversation != nil else {
                completionHandler(nil,false)
                return
            }
            guard let resultConv = conversation else { return }
            for conv in resultConv {
                self.arrayConversation.append(conv)
            }
            self.arrayConversation = self.arrayConversation.removeDuplicates()
            completionHandler(nil,true)
            
        }
    }
    //func for messageVC
    ///func request update conversation message
    func updateConversation(update: [String:Any], completionHandler: @escaping(Bool) -> Void){
        guard let conversationSecure = conversation, let id = conversationSecure.id else { return }
        firebaseServiceSession.dataManager.updateConversation(update: update, id: id) { (bool) in
            guard bool == true else {
                completionHandler(false)
                return
            }
            completionHandler(true)
        }
    }
    ///func for delete conversation when announce in delete
    func deleteConversation(announceID: String, completionHandler: @escaping(Error?) -> Void) {
        firebaseServiceSession.dataManager.deleteConversation(announceId: announceID) { (error) in
            guard error == nil else {
                completionHandler(error)
                return
            }
            completionHandler(nil)
        }
    }
    ///for transformate message in dict for firebase
    func transformeMessageInDic() {
        for message in messages {
            messageDict.append(message.representation)
        }
    }
    ///decode conversation of database for swift
    func decodeConversationMessage() {
        guard let conversationSecure = conversation, let array = conversationSecure.arrayMessage else { return }
        for message in array {
            messages.append(decodeMessage(message: message))
        }
    }
    ///decode message of database for swift
    private func decodeMessage(message: [String:Any]) -> Message {
        let messageText = message["message"] as! String
        let id = message["senderID"] as! String
        let name = message["senderName"] as! String
        let timeInterval = message["created"] as! Timestamp
        let date = timeInterval.dateValue()
        let message = Message(created: date, message: messageText, senderID: id, senderName: name)
        return message
    }
    
    //func for firstMessageVC
    ///func for prepare the message for sending, and create new conversation if no existing
    func prepareSendMessage(text: String) {
        createNewMessage(text: text)
        if isExisting == true {
            addMessageInConversation()
        } else {
            newConversation = createNewConversation()
            guard let newConversationSecure = newConversation else { return }
            addConversation(conversation: newConversationSecure)
        }
    }
    ///create new message
    private func createNewMessage(text: String) {
        let message = Message(text: text, user: CurrentUserManager.shared.user)
        arrayMessageRep.append(message.representation)
        arrayMessage.append(message)
    }
    ///create new conversation
    private func createNewConversation() -> Conversation? {
        guard let announceSecure = announce else { return nil }
        idAnnounceUser = announceSecure.idUser
        guard let announceId = announceSecure.id else { return nil}
        let conversation = Conversation(id: nil, idAnnounce: announceId, name: announceSecure.title, idUser1: CurrentUserManager.shared.user.senderId, idUser2: idAnnounceUser, arrayMessage: arrayMessageRep)
        return conversation
    }
    ///func request pull for add message in conversation Firebase
    private func addMessageInConversation() {
        firebaseServiceSession.dataManager.addMessageInConversation(documentID: documentID, arrayMessageRep: arrayMessageRep) { (bool) in
            guard bool == true else { return }
        }
    }
    ///func for add conversation in firebase
    private func addConversation(conversation: Conversation) {
        firebaseServiceSession.dataManager.addConversation(conversation: conversation, documentID: documentID) { (bool) in
            guard bool == true else { return }
        }
    }
    ///we check if the conversation already exists or not
    func readConversation() {
        firebaseServiceSession.dataManager.readConversation(documentID: documentID) { [weak self] (bool) in
            guard let self = self else { return }
            guard bool == true else {
                return
            }
            self.isExisting = true
        }
    }
    ///func for create IDConversation fot new Conversation or retrieve holder conversation and update
    func createOrRetrieveDocumentID() {
        guard let announceSecure = announce else { return }
        guard let announceId = announceSecure.id else { return }
        documentID = CurrentUserManager.shared.user.senderId + announceSecure.idUser + announceId
    }
    
}
