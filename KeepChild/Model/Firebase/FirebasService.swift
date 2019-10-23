//
//  FirebasService.swift
//  KeepChild
//
//  Created by Clément Martin on 22/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation

class FirebaseService {
    var dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
}
