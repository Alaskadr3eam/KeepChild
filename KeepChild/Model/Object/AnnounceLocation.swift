//
//  AnnounceLocation.swift
//  KeepChild
//
//  Created by Clément Martin on 10/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import MapKit

class AnnounceLocation: NSObject, MKAnnotation {
    
    var id: String?
    var idUser: String
    var title: String?
    var descriptionAnnounce: String
    var price: String
    var coordinate: CLLocationCoordinate2D
    var tel: Bool
    var semaine: Semaine
    var day: Bool
    var night: Bool
    
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
}
