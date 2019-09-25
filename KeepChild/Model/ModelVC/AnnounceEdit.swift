//
//  File.swift
//  KeepChild
//
//  Created by Clément Martin on 15/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CoreLocation


class AnnounceEdit {
    var manageFireBase = ManageFireBase()
    var idUser = UserDefaults.standard.string(forKey: "userID")
    
    var announce: Announce!
    var location: CLLocationCoordinate2D!
    
    func addData(announce: Announce) {
        manageFireBase.addData(announce: announce)
    }

    func createAnnounce(title: String, description: String,price: String, tel: Bool) {
      
        guard let idUser = idUser else { return }
        let title = title
        let description = description
        let price = price
        let latitude = location.latitude
        let longitute = location.longitude
        let coordinate = GeoPoint(latitude: latitude, longitude: longitute)
        let tel = tel
        let announceCreate = Announce(id: "",idUser: idUser , title: title, description: description, price: price, coordinate: coordinate, tel: tel)
        announce = announceCreate
    }

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
            self.location = location.coordinate
            completionHandler(location.coordinate, nil)
        }
    }
    
   
}
