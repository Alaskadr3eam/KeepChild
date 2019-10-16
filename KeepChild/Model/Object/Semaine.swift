//
//  Semaine.swift
//  KeepChild
//
//  Created by Clément Martin on 10/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import CodableFirebase

struct Semaine: Codable, Equatable {
    var idUser: String?
    var lundi: Bool?
    var mardi: Bool?
    var mercredi: Bool?
    var jeudi: Bool?
    var vendredi: Bool?
    var samedi: Bool?
    var dimanche: Bool?
    
}
