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

//public typealias GeoPoint = CLLocationCoordinate2D

struct Announce: Codable {
    

    var id: String?
    var idUser: String
    var title: String
    var description: String
    var price: String
    var semaine: Semaine
    //var geoPoint = CustomGeoPoint(latitude: 0, longitude: 0)
    var coordinate: GeoPoint
    var tel: Bool
    
   /* init(id: String, idUser: String, title: String, description: String, price: String, coordinate: GeoPoint) {
        self.id = id
        self.idUser = idUser
        self.title = title
        self.description = description
        self.price = price
        self.coordinate = coordinate
    }*/
   
}

struct Semaine: Codable {
    var idUser: String
    var lundi: Bool
    var mardi: Bool
    var mercredi: Bool
    var jeudi: Bool
    var vendredi: Bool
    var samedi: Bool
    var dimanche: Bool
}


extension GeoPoint: GeoPointType {}

/*
struct Coordinate: Codable {
    let lat: Double
    let long: Double
    
    init(lat: Double, long: Double) {
        self.lat = lat
        self.long = long
    }
}
 */
/*
struct Adresse: Codable {
    var lat: Int?
    var long: Int?
}
 */
/*
struct AnnounceListData: Codable {
    var announce: [Announce]
}
*/
struct ProfilUser: Codable {
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
}

class AnnounceLocation: NSObject, MKAnnotation {
    
    
    var id: String?
    var idUser: String
    var title: String?
    var descriptionAnnounce: String
    var price: String
    var coordinate: CLLocationCoordinate2D
    var tel: Bool
    
    //var city: String
    //var postalCode: String
    
    init(id: String, idUser: String, title: String, descriptionAnnounce: String, price: String, coordinate: CLLocationCoordinate2D,tel: Bool) {
        self.id = id
        self.idUser = idUser
        self.title = title
        self.descriptionAnnounce = descriptionAnnounce
        self.price = price
        self.coordinate = coordinate
        self.tel = tel
        
        super.init()
    }
    
}

struct User {
    var id: String
    var email: String
}
