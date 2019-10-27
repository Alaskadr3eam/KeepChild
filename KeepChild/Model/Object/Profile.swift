//
//  ProfilUser.swift
//  KeepChild
//
//  Created by Clément Martin on 10/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import CodableFirebase

struct Profile: Codable, Equatable {
    var id: String?
    var idUser: String
    var name: String
    var firstName: String
    var pseudo: String
    var mail: String
    var phone: String
    var postalCode: String
    var city: String
}
