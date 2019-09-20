//
//  File.swift
//  KeepChild
//
//  Created by Clément Martin on 17/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import CoreLocation

class DetailAnnounce {
    
    var manageFireBase = ManageFireBase()
    
    var idUser = UserDefaults.standard.string(forKey: "userID")
    var announce: Announce!
    var profil: ProfilUser!
    
    var locality = String()
    var administrativeArea = String()
    var postalCode = String()
    
    func retrieveProfilUser(collection: String, field: String, equal: String, completionHandler: @escaping(Error?,[ProfilUser]?) -> Void) {
        manageFireBase.retrieveProfilUser(collection: collection, field: field, equal: equal) { [weak self] (error, profilUser) in
            guard error == nil else {
                completionHandler(error,nil)
                return
            }
            guard let self = self else { return }
            guard let profilArray = profilUser else { return }
            self.profil = profilArray[0]
            completionHandler(nil,profilArray)
        }
    }

    func deleteAnnounce(announceId: String) {
        manageFireBase.deleteAnnounce(announceId: announceId)
    }
    
    func retrieveAdresseWithLocation(location: CLLocation, geocoder: CLGeocoder, completionHandler: @escaping(Error?,CLPlacemark?) -> Void) {
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            guard error == nil else {
                completionHandler(error,nil)
                return
            }
            guard let placemark = placemarks else { return }
            //let placemark = placemarks! as [CLPlacemark]
            if placemark.count > 0 {
                let placemark = placemarks![0]
                self.locality = placemark.locality!
                self.administrativeArea = placemark.administrativeArea!
                self.postalCode = placemark.postalCode!
                completionHandler(nil,placemark)
            }
            
        })
    }
}
