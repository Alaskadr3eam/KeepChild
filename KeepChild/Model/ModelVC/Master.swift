//
//  Master.swift
//  KeepChild
//
//  Created by Clément Martin on 28/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation

class Master {
    var manageFireBase = ManageFireBase()
    var announceList = [Announce]()

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
}
