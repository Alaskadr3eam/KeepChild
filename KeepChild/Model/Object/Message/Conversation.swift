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


struct Conversation: Equatable {
    
    var id: String?
    let idAnnounce: String
    let name: String
    let idUser1: String
    let idUser2: String
    let arrayMessage: [[String:Any]]?
    
    static func == (lhs: Conversation, rhs: Conversation) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Conversation: DatabaseRepresentation {
    
    var representation: [String : Any] {
        var rep: [String : Any] = [
            "name": name,
            "idAnnounce": idAnnounce,
            "idUser1": idUser1,
            "idUser2":idUser2,
            "message": arrayMessage as Any
        ]
        
        if let id = id {
            rep["id"] = id
        }
        
        return rep
    }
    
}
