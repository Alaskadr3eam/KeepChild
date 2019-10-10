//
//  Announce.swift
//  KeepChild
//
//  Created by Clément Martin on 13/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import MapKit
import CodableFirebase
import Firebase
import MessageKit

struct Announce: Codable, Equatable {
    
    var id: String?
    var idUser: String
    var title: String
    var description: String
    var price: String
    var semaine: Semaine
    var coordinate: GeoPoint
    var tel: Bool
    var day: Bool
    var night: Bool
    
    static func == (lhs: Announce, rhs: Announce) -> Bool {
        return lhs.id == rhs.id
    }
}

/*struct Semaine: Codable {
    var idUser: String?
    var lundi: Bool?
    var mardi: Bool?
    var mercredi: Bool?
    var jeudi: Bool?
    var vendredi: Bool?
    var samedi: Bool?
    var dimanche: Bool?
    
}*/

extension GeoPoint: GeoPointType {}

/*struct ProfilUser: Codable {
    var id: String?
    var iDuser: String
    var nom: String
    var prenom: String
    var pseudo: String
    var mail: String
    var tel: Int
    var postalCode: String
    var city: String
    //var coordinate: GeoPoint?
  //  var photo: String
}*/

/*class AnnounceLocation: NSObject, MKAnnotation {
    
    
    var id: String?
    var idUser: String
    var title: String?
    var descriptionAnnounce: String
    var price: String
    var coordinate: CLLocationCoordinate2D
    var tel: Bool
    var semaine: Semaine
    //var dayList: [String]
    var day: Bool
    var night: Bool
    
    //var city: String
    //var postalCode: String
    
    init(id: String, idUser: String, title: String, descriptionAnnounce: String, price: String, coordinate: CLLocationCoordinate2D,tel: Bool,semaine: Semaine, day: Bool, night: Bool) {
        self.id = id
        self.idUser = idUser
        self.title = title
        self.descriptionAnnounce = descriptionAnnounce
        self.price = price
        self.coordinate = coordinate
        self.tel = tel
        self.semaine = semaine
        self.day = day
        self.night = night
        
        
        super.init()
    }
    
}*/

/*struct User: SenderType, Equatable {
    var senderId: String
    var displayName: String {
        return CurrentUserManager.shared.profil.pseudo
    }
    var email: String
}*/
