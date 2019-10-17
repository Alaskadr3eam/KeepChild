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

class Filter {
    var distanceMile = Double()
    let locationManager = CLLocationManager()
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
            FilterSearch.shared.latChoice = location.coordinate.latitude
            FilterSearch.shared.longChoice = location.coordinate.longitude
            completionHandler(location.coordinate, nil)
        }
    }
    //autorize location
    func checkLocationAuthorizationStatus(completionHandler: @escaping(Bool) -> Void) {
        FilterSearch.shared.removeLocationValue()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // locationManager.distanceFilter = 100000
            guard let lat = locationManager.location?.coordinate.latitude, let long = locationManager.location?.coordinate.longitude else {
                completionHandler(false)
                return }
            
            FilterSearch.shared.addLocationValue(lat: lat,long: long)
            completionHandler(true)
        } else {
            locationManager.requestWhenInUseAuthorization()
            completionHandler(false)
        }
    }
    //prepare queryLoc
    func prepareQueryLoc() {
        let lat = 0.0144927536231884
        let lon = 0.0181818181818182
        
        let lowerLat = Double(FilterSearch.shared.latChoice) - (lat * distanceMile)
        let lowerLon = Double(FilterSearch.shared.longChoice) - (lon * distanceMile)
        
        let greaterLat = Double(FilterSearch.shared.latChoice) + (lat * distanceMile)
        let greaterLon = Double(FilterSearch.shared.longChoice) + (lon * distanceMile)
        
        let lesserGeopoint = GeoPoint(latitude: lowerLat, longitude: lowerLon)
        let greaterGeopoint = GeoPoint(latitude: greaterLat, longitude: greaterLon)
        FilterSearch.shared.lesserGeopoint = lesserGeopoint
        FilterSearch.shared.greaterGeopoint = greaterGeopoint
    }
    
    //retireve Distance Selectionné
    func disTanceForSlider() -> Float {
        let distanceMile = FilterSearch.shared.regionRadius / 1000
        let distanceKm = Double(distanceMile * 1.60934)
        let value = Float(distanceKm)
        return value
    }

    func distanceInMile(value: Int) {
        distanceMile = Double(value) / 1.60934
        FilterSearch.shared.regionRadius = Double(value) * 1000
    }
}
