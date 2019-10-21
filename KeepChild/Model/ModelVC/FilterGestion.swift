//
//  Filter.swift
//  KeepChild
//
//  Created by Clément Martin on 10/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

class FilterGestion {
    
    var filter: Filter!
    
    var dayFilter = [String:Bool]()
    var momentDay = [String:Bool]()
    var lesserGeopoint: GeoPoint!
    var greaterGeopoint: GeoPoint!
    var latChoice: CLLocationDegrees!
    var longChoice: CLLocationDegrees!
    var regionRadius: CLLocationDistance!
    var profilLocIsSelected = false
    
    var distanceMile = Double()
    let locationManager = CLLocationManager()
    //func create filter
    func createFilterForSearch() {
        
        filter = Filter(dayFilter: dayFilter, momentDay: momentDay, lesserGeopoint: lesserGeopoint, greaterGeopoint: greaterGeopoint, regionRadius: regionRadius, latChoice: latChoice, longChoice: longChoice, profilLocIsSelected: profilLocIsSelected)
    }
    //request geocoder for transalte adress string in CLLlocation
    func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            guard error == nil else {
                completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
                return
            }
            guard let placemark = placemarks?[0] else { return }
            let location = placemark.location!
            /*FilterSearch.shared.latChoice = location.coordinate.latitude
            FilterSearch.shared.longChoice = location.coordinate.longitude*/
            self.latChoice = location.coordinate.latitude
            self.longChoice = location.coordinate.longitude
            completionHandler(location.coordinate, nil)
        }
    }
    //autorize location
    func checkLocationAuthorizationStatus(completionHandler: @escaping(Bool) -> Void) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // locationManager.distanceFilter = 100000
            guard let lat = locationManager.location?.coordinate.latitude, let long = locationManager.location?.coordinate.longitude else {
                completionHandler(false)
                return }
            self.latChoice = lat
            self.longChoice = long
            //FilterSearch.shared.addLocationValue(lat: lat,long: long)
            completionHandler(true)
        } else {
            locationManager.requestWhenInUseAuthorization()
            completionHandler(false)
        }
    }
    func prepareQueryIsPossibleOrNot() -> Bool {
        if latChoice == nil && longChoice == nil {
            return false
        }
        return true
    }
    //prepare queryLoc
    func prepareQueryLoc() {
        
        let lat = 0.0144927536231884
        let lon = 0.0181818181818182
        
        let lowerLat = Double(latChoice) - (lat * distanceMile)
        let lowerLon = Double(longChoice) - (lon * distanceMile)
        
        let greaterLat = Double(latChoice) + (lat * distanceMile)
        let greaterLon = Double(longChoice) + (lon * distanceMile)
        
        let lesserGeopoint1 = GeoPoint(latitude: lowerLat, longitude: lowerLon)
        let greaterGeopoint1 = GeoPoint(latitude: greaterLat, longitude: greaterLon)
        lesserGeopoint = lesserGeopoint1
        greaterGeopoint = greaterGeopoint1
    }
    
    //retireve Distance Selectionné
    func disTanceForSlider() -> Float? {
        guard let regionRadius = filter.regionRadius else { return nil }
        let distanceMeters = Double(regionRadius)
        let distanceKm = distanceMeters / 1000
        let value = Float(distanceKm)
        return value
    }

    func distanceInMile(value: Float) {
        distanceMile = Double(value) / 1.60934
    }
    
    func distanceInMetersForRegionRadiusMapKit(value: Float) {
        regionRadius = Double(value) * 1000
    }
    
    func fiterIsComplete(alert: Void) {
        //filterSearchIsComplete() ? createFilterForSearch() : alert(alert)
    }
    
    func alert(_ alert: Void) {
        alert
    }
    func filterSearchIsComplete() -> Bool {
        if dayFilter.count == 0 && momentDay.count == 0 {
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
