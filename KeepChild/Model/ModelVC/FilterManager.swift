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

class FilterManager {
    //MARK: - Properties
    var filter: Filter?
    var dayFilter = [String:Bool]()
    var momentDay = [String:Bool]()
    var lesserGeopoint: GeoPoint?
    var greaterGeopoint: GeoPoint?
    var latChoice: CLLocationDegrees?
    var longChoice: CLLocationDegrees?
    var regionRadius: CLLocationDistance?
    var profilLocIsSelected = Bool()
    var distanceMile = Double()
    
    //MARK: - Request geocoder
    // for transalte adress string in CLLlocation
    func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D?, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            guard error == nil else {
                completionHandler(nil, error as NSError?)
                return
            }
            guard let placemark = placemarks?[0] else { return }
            guard let location = placemark.location else { return }
            self.latChoice = location.coordinate.latitude
            self.longChoice = location.coordinate.longitude
            completionHandler(location.coordinate, nil)
        }
    }
    //MARK: - Func Helpers
    //func create filter
    ///function that allows you create the filter object for the request
    func createFilterForSearch() {
        guard let lesserGeopointSecure = lesserGeopoint,
            let greaterGeopointSecure = greaterGeopoint,
            let regionRadiusSecure = regionRadius,
            let latSecure = latChoice,
            let longSecure = longChoice else { return }
        filter = Filter(dayFilter: dayFilter, momentDay: momentDay, lesserGeopoint: lesserGeopointSecure, greaterGeopoint: greaterGeopointSecure, regionRadius: regionRadiusSecure, latChoice: latSecure, longChoice: longSecure, profilLocIsSelected: profilLocIsSelected)
    }
    ///function that allows you verify is possible prepare query lesser and greather geopoint
    func prepareQueryIsPossibleOrNot() -> Bool {
        if latChoice == nil && longChoice == nil {
            return false
        }
        return true
    }
    ///function that allows you prepare lesser and greather geopint for the query request with filter
    func prepareQueryLoc() {
        guard let latSecure = latChoice, let longSecure = longChoice else { return }
        let lat = 0.0144927536231884
        let lon = 0.0181818181818182
        
        let lowerLat = Double(latSecure) - (lat * distanceMile)
        let lowerLon = Double(longSecure) - (lon * distanceMile)
        
        let greaterLat = Double(latSecure) + (lat * distanceMile)
        let greaterLon = Double(longSecure) + (lon * distanceMile)
        
        let lesserGeopoint1 = GeoPoint(latitude: lowerLat, longitude: lowerLon)
        let greaterGeopoint1 = GeoPoint(latitude: greaterLat, longitude: greaterLon)
        lesserGeopoint = lesserGeopoint1
        greaterGeopoint = greaterGeopoint1
    }
    
    ///retireve Distance Selectionné
    func disTanceForSlider() -> Float? {
        guard let filterSecure = filter else { return nil }
        guard let regionRadius = filterSecure.regionRadius else { return nil }
        let distanceMeters = Double(regionRadius)
        let distanceKm = distanceMeters / 1000
        distanceMile = distanceKm / 1.60934
        let value = Float(distanceKm)
        return value
    }
    ///transformate distance in mile
    func distanceInMile(value: Float) {
        distanceMile = Double(value) / 1.60934
    }
    ///transformate distance in meters
    func distanceInMetersForRegionRadiusMapKit(value: Float) {
        regionRadius = Double(value) * 1000
    }
    ///verify if variable for create filter object is not nil
    func filterSearchIsComplete() -> Bool {
        if dayFilter.count == 0 && momentDay.count == 0 {
            return false
        } else if lesserGeopoint == nil && greaterGeopoint == nil {
            return false
        } else if regionRadius == nil {
            return false
        } else if latChoice == nil && longChoice == nil {
            return false
        } else {
            return true
        }
    }
}
