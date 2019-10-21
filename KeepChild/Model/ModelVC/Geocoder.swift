//
//  Geocoder.swift
//  KeepChild
//
//  Created by Clément Martin on 19/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

/*import Foundation
import CoreLocation

protocol LocationService {
    
    typealias LocationServiceCompletionHandler = ([CLLocation], Error?) -> Void
    
    func geocode(addressString: String?, completionHandler: @escaping LocationServiceCompletionHandler)
    
}

class Geocoder: LocationService {
    // MARK: - Properties
    
    private lazy var geocoder = CLGeocoder()
    private let locationService: LocationService
    
    // MARK: - Initialization
    
    init(query: String, locationService: LocationService) {
        // Set Location Service
        self.locationService = locationService

    }

    func geocode(addressString: String?, completionHandler: @escaping Geocoder.LocationServiceCompletionHandler) {
        guard let addressString = addressString else {
            completionHandler([], nil)
            return
        }
        
        // Geocode Address String
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            var locations: [CLLocation] = []
            
            if let error = error {
                print("Unable to Forward Geocode Address (\(error))")
                
            } else if let _placemarks = placemarks {
                // Update Locations
                locations = _placemarks.flatMap({ (placemark) -> CLLocation? in
                    guard let name = placemark.name else { return nil }
                    guard let location = placemark.location else { return nil }
    
                    return CLLocation(name: name, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                })
            }
            
            completionHandler(locations, nil)
        }
    }
    
}*/
