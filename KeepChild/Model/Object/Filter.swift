//
//  Filter.swift
//  KeepChild
//
//  Created by Clément Martin on 20/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

struct Filter {
    /*var dayFilter: [String:Bool]?
    var momentDay: [String:Bool]?
    var lesserGeopoint: GeoPoint?
    var greaterGeopoint: GeoPoint?
    var regionRadius: CLLocationDistance?
    var profilLocIsSelected = false*/

    var dayFilter: [String:Bool]
    var momentDay: [String:Bool]
    var lesserGeopoint: GeoPoint?
    var greaterGeopoint: GeoPoint?
    var regionRadius: CLLocationDistance?
    var profilLocIsSelected = false
    var latChoice: Double?
    var longChoice: Double?
    
    init(dayFilter: [String:Bool],momentDay: [String:Bool],lesserGeopoint: GeoPoint,greaterGeopoint: GeoPoint,regionRadius: CLLocationDistance,latChoice: Double,longChoice: Double,profilLocIsSelected: Bool) {
        self.dayFilter = dayFilter
        self.momentDay = momentDay
        self.lesserGeopoint = lesserGeopoint
        self.greaterGeopoint = greaterGeopoint
        self.regionRadius = regionRadius
        self.latChoice = latChoice
        self.longChoice = longChoice
        self.profilLocIsSelected = true
    }
}
