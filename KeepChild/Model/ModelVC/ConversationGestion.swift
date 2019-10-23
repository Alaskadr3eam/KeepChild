//
//  ManageConversation.swift
//  KeepChild
//
//  Created by Clément Martin on 10/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ConversationGestion {
    
    private var firebaseServiceSession = FirebaseService(dataManager: ManagerFirebase())
    
    init(firebaseServiceSession: FirebaseService) {
        self.firebaseServiceSession = firebaseServiceSession
    }
    
    //properties for conversationVC
    var arrayConversation = [Conversation]()
    var arrayMessage = [Message]()
    var conversation: Conversation!
    var newConversation: Conversation!
    //properties for messageVC
    var messages = [Message]()
    var messageDict = [[String : Any]]()
    //properties for firstMessageVC
    var idAnnounceUser = String()
    var arrayMessageRep = [[String: Any]]()
    var announce: Announce!
    var isExisting: Bool = false
    var documentID = String()
    
    //func for conversationVC
    func retrieveConversion(field: String, completionHandler: @escaping(Error?,Bool?) -> Void) {
        firebaseServiceSession.dataManager.retrieveConversationUser(field: field) { [weak self] (error, conversation) in
            guard let self = self else { return }
            guard error == nil else {
                completionHandler(error,nil)
                return }
            guard conversation != nil else {
                completionHandler(nil,false)
                //self.requestIdUser2()
                return }
            guard let resultConv = conversation else { return }
            for conv in resultConv {
                self.arrayConversation.append(conv)
            }
            self.arrayConversation = self.arrayConversation.removeDuplicates()
            completionHandler(nil,true)
            
        }
    }
    //func for messageVC
    //func request update conversation message
    func updateConversation(update: [String:Any], completionHandler: @escaping(Bool) -> Void){
        guard let id = conversation.id else { return }
        firebaseServiceSession.dataManager.updateConversation(update: update, id: id) { (bool) in
            guard bool == true else {
                completionHandler(false)
                return
            }
            completionHandler(true)
        }
    }
    
    func transformeMessageInDic() {
        for message in messages {
            messageDict.append(message.representation)
        }
    }
    
    func decodeConversationMessage() {
        for message in conversation.arrayMessage! {
            messages.append(decodeMessage(message: message))
        }
    }
    
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
    func prepareSendMessage(text: String) {
        createNewMessage(text: text)
        if isExisting == true {
            addMessageInConversation()
        } else {
            newConversation = createNewConversation()
            addConversation(conversation: newConversation)
        }
    }
    //create new message
    private func createNewMessage(text: String) {
        let message = Message(text: text, user: CurrentUserManager.shared.user)
        arrayMessageRep.append(message.representation)
        arrayMessage.append(message)
    }
    //create new conversation
    private func createNewConversation() -> Conversation {
        idAnnounceUser = announce.idUser
        let conversation = Conversation(id: nil, name: announce.title, idUser1: CurrentUserManager.shared.user.senderId, idUser2: idAnnounceUser, arrayMessage: arrayMessageRep)
        return conversation
    }
    //func request pull for add message in conversation Firebase
    private func addMessageInConversation() {
        firebaseServiceSession.dataManager.addMessageInConversation(documentID: documentID, arrayMessageRep: arrayMessageRep) { (bool) in
            guard bool == true else { return }
        }
    }
    
    private func addConversation(conversation: Conversation) {
        firebaseServiceSession.dataManager.addConversation(conversation: conversation, documentID: documentID) { (bool) in
            guard bool == true else { return }
        }
    }
    //we check if the conversation already exists or not
    func readConversation() {
        firebaseServiceSession.dataManager.readConversation(documentID: documentID) { [weak self] (bool) in
            guard let self = self else { return }
            guard bool == true else {
                return
            }
            self.isExisting = true
        }
    }
    //func for create IDConversation fot new Conversation or retrieve holder conversation and update
    func createOrRetrieveDocumentID() {
        guard let announceId = announce.id else { return }
        documentID = CurrentUserManager.shared.user.senderId + announce.idUser + announceId
    }
    
}
