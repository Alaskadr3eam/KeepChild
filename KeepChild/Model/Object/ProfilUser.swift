//
//  ProfilUser.swift
//  KeepChild
//
//  Created by Clément Martin on 10/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import CodableFirebase

struct ProfilUser: Codable, Equatable {
    var id: String?
    var iDuser: String
    var nom: String
    var prenom: String
    var pseudo: String
    var mail: String
    var tel: String
    var postalCode: String
    var city: String
}
