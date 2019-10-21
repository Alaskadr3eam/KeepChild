//
//  ManageConversation.swift
//  KeepChild
//
//  Created by Clément Martin on 10/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ManageConversation {
    //properties for conversationVC
    var arrayConversation = [Conversation]()
    var arrayMessage = [Message]()
    var conversation: Conversation!
    //properties for messageVC
    var messages = [Message]()
    var messageDict = [[String : Any]]()
    //properties for firstMessageVC
    var idAnnounceUser = String()
    //var arrayMessage = [Message]()
    var arrayMessageRep = [[String: Any]]()
    var announce: Announce!
    var isExisting: Bool = false
    var documentID = String()
    
    //func for conversationVC
    func retrieveConversion(field: String, completionHandler: @escaping(Error?,Bool?) -> Void) {
        DependencyInjection.shared.dataManager.retrieveConversationUser(field: field) { [weak self] (error, conversation) in
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
            //self.requestIdUser2()
        }
    }
    //func for messageVC
    //func request update conversation message
    func updateConversation(update: [String:Any], action: Void) {
        guard let id = conversation.id else { return }
        Firestore.firestore().collection("Conversation").document(id).updateData(update) { (error) in
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                return
            }
            action
            //self.messagesCollectionView.scrollToBottom()
        }
    }
    func transformeMessageInDic() {
        for message in messages {
            messageDict.append(message.representation)
        }
    }

    func decodeConversationMessage() {
        for message in conversation.arrayMessage! {
           /* let messageText = message["message"] as! String
            let id = message["senderID"] as! String
            let name = message["senderName"] as! String
            let timeInterval = message["created"] as! Timestamp
            let date = timeInterval.dateValue()
            let message2 = Message(created: date, message: messageText, senderID: id, senderName: name)*/
            messages.append(decodeMessage(message: message))
        }
    }

    func decodeMessage(message: [String:Any]) -> Message {
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
            let conversation = createNewConversation()
            addConversation(conversation: conversation)
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
        Firestore.firestore().collection("Conversation").document(documentID).updateData(["message" : FieldValue.arrayUnion(arrayMessageRep)])
    }

    private func addConversation(conversation: Conversation) {
        Firestore.firestore().collection("Conversation").document(documentID).setData(conversation.representation)
    }
    //we check if the conversation already exists or not
    func readConversation() {
        DependencyInjection.shared.dataManager.readConversation(documentID: documentID) { [weak self] (bool) in
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
