//
//  File.swift
//  KeepChild
//
//  Created by Clément Martin on 15/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation

class AnnounceEdit {
    var manageFireBase = ManageFireBase()
    var idUser = UserDefaults.standard.string(forKey: "userID")
    
    func addData(announce: Announce) {
        manageFireBase.addData(announce: announce)
    }

    
}
