//
//  File.swift
//  KeepChild
//
//  Created by Clément Martin on 17/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import CoreLocation

/*class DetailAnnounce {
    
   // var manageFireBase = ManageFireBase()
    
    
    var announce: Announce!

    var lat: CLLocationCoordinate2D!
    var long: CLLocationCoordinate2D!
    var locationAnnounce: CLLocationCoordinate2D!


    func deleteAnnounce(announceId: String, completionHandler: @escaping(Error?) -> Void) {
        DependencyInjection.shared.dataManager.deleteAnnounce(announceId: announceId) { (error) in
            guard error == nil else {
                completionHandler(error)
                return
            }
            completionHandler(nil)
        }
    }
    
    /*func deleteAnnounce(announceId: String) {
        DependencyInjection.shared.dataManager.deleteAnnounce(announceId: announceId) { (error) in
            guard error == nil else {
                //alert error
                return
            }
            //alert reussite
        }
       // manageFireBase.deleteAnnounce(announceId: announceId)
    }*/
    
    func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            guard error == nil else {
                completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
                return
            }
            guard let placemark = placemarks?[0] else { return }
            let location = placemark.location!
            self.locationAnnounce = location.coordinate
            completionHandler(location.coordinate, nil)
        }
    }
}*/
