//
//  Announce.swift
//  KeepChild
//
//  Created by Clément Martin on 13/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import CodableFirebase
import Firebase


struct Announce: Codable, Equatable {
    
    var id: String?
    var idUser: String
    var title: String
    var description: String
    var price: String
    var semaine: Semaine
    var coordinate: GeoPoint
    var phone: Bool
    var day: Bool
    var night: Bool
    
    static func == (lhs: Announce, rhs: Announce) -> Bool {
        return lhs.id == rhs.id
    }
}

extension GeoPoint: GeoPointType {}
