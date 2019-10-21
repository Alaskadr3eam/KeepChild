//
//  CurrentFilterSearch.swift
//  KeepChild
//
//  Created by Clément Martin on 10/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

/*import Foundation
import CoreLocation
import Firebase

class FilterSearch {
    
    static var shared = FilterSearch()
    
    private init () {}
    
    var dayFilter = [String:Bool]()
    var momentDay = [String:Bool]()
    var latChoice: CLLocationDegrees!
    var longChoice: CLLocationDegrees!
    var lesserGeopoint: GeoPoint!
    var greaterGeopoint: GeoPoint!
    var regionRadius: CLLocationDistance!
    var profilLocIsSelected = false
    
    func initLocFilterSearch() {
        greaterGeopoint = nil
        lesserGeopoint = nil
    }
    
    func initFilterDayAndMoment() {
        dayFilter = [String:Bool]()
        momentDay = [String:Bool]()
    }

    func removeLocationValue() {
        latChoice = nil
        longChoice = nil
    }

    func addLocationValue(lat: CLLocationDegrees, long: CLLocationDegrees) {
        latChoice = lat
        longChoice = long
    }

    func filterSearchIsComplete() -> Bool {
        if dayFilter.count == 0 && momentDay.count == 0 {
            return false
        } else if latChoice == nil && longChoice == nil {
            return false
        } else if lesserGeopoint == nil && greaterGeopoint == nil {
            return false
        } else if regionRadius == nil {
            return false
        } else {
            return true
        }
    }
}
*/
