//
//  Conversation.swift
//  KeepChild
//
//  Created by Clément Martin on 02/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import CodableFirebase
import Firebase
import MessageKit
import FirebaseFirestore


struct Conversation {
    var id: String?
    let name: String
    let idUser1: String
    let idUser2: String
    let arrayMessage: [[String:Any]]?
}

extension Conversation: DatabaseRepresentation {
    
    var representation: [String : Any] {
        var rep: [String : Any] = [
            "name": name,
            "idUser1": idUser1,
            "idUser2":idUser2,
            "message": arrayMessage
        ]
        
        if let id = id {
            rep["id"] = id
        }
        
        return rep
    }
    
}

struct Message2: MessageType {
    
    var id: String?
    var sender: SenderType/* {
        return user
    }*/
    var messageId: String {
        return id ?? UUID().uuidString
    }
    var sentDate: Date
    var kind: MessageKind {
        return .text(content)
    }
    var content: String
    
    var user: User
    
    var downloadURL: URL? = nil
    
    private init(content: String, user: User) {
        self.content = content
        sender = Sender(senderId: CurrentUserManager.shared.user.senderId, displayName: CurrentUserManager.shared.profil.pseudo)
        self.user = user
        sentDate = Date()
    }
    init(text: String,user: User) {
        self.init(content: text,user: user)
    }
    init(created: Date, message: String, senderID: String,senderName:String) {
        self.content = message
        self.sentDate = created
        self.sender = Sender(senderId: senderID, displayName: senderName)
        user = User(senderId: senderID, email: senderName)
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let sentDate = data["created"] as? Date else {
            return nil
        }
        guard let senderID = data["senderID"] as? String else {
            return nil
        }
        guard let senderName = data["senderName"] as? String else {
            return nil
        }
        
        user = User(senderId: senderID, email: senderName)
        id = document.documentID
        
        self.sentDate = sentDate
        sender = Sender(id: senderID, displayName: senderName)
        
        if let content = data["content"] as? String {
            self.content = content
            downloadURL = nil
        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            downloadURL = url
            content = ""
        } else {
            return nil
        }
    }

}

extension Message2: DatabaseRepresentation {
    
    var representation: [String : Any] {
        let rep: [String : Any] = [
            "created": sentDate,
            "senderID": sender.senderId,
            "senderName": sender.displayName,
            "message": content
        ]
        
       /* if let url = downloadURL {
            rep["url"] = url.absoluteString
        } else {
            rep["content"] = content
        }*/
        
        return rep
    }
    
}

extension Message2: Comparable {
    
    static func == (lhs: Message2, rhs: Message2) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Message2, rhs: Message2) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
}

protocol DatabaseRepresentation {
    var representation: [String: Any] { get }
}
