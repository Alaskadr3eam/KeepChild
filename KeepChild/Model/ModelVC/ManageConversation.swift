//
//  ManageConversation.swift
//  KeepChild
//
//  Created by Clément Martin on 10/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation

class ManageConversation {
    
    var arrayConversation = [Conversation]()
    
    var arrayMessage = [Message]()
    
    var conversation: Conversation!
    
    func retrieveConversion(field: String, completionHandler: @escaping(Error?,Bool?) -> Void) {
        DependencyInjection.shared.dataManager.retrieveConversationUser(field: "idUser1") { [weak self] (error, conversation) in
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
}
