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
    //var idUser = UserDefaults.standard.string(forKey: "userID")
    var delegate: AnnounceEditDelegate?
    
    var announce: Announce!
    var location: CLLocationCoordinate2D!
    var jour: String!
    

    func encodeObjectInData(semaine: Semaine) {
        if let encodedData = try? JSONEncoder().encode(semaine) {
            UserDefaults.standard.set(encodedData, forKey: "semaine")
        }
    }
    
    func decodedDataInObject() -> Semaine? {
        guard let decodeUserDefault = UserDefaults.standard.data(forKey: "semaine") else { return nil }
        let decoded = decodeUserDefault
        if let loadedSemaine = try? JSONDecoder().decode(Semaine.self, from: decoded) {
            return loadedSemaine
        }
        return nil
    }

    func removeUserDefaultObject(forkey: String) {
        UserDefaults.standard.removeObject(forKey: forkey)
    }
    
    func addData(announce: Announce) {
        manageFireBase.addData(announce: announce) { bool in
            guard bool == true else {
                self.delegate?.alert("Annonce non envoyé", "Désolé, votre annonce n'a pas pu etre sauvegardée. Vérifiez votre connexion internet.")
                return
            }
            self.delegate?.alert("Annonce envoyé", "Félicitation, votre annonce a été enregistré.")
        }
    }

    func createAnnounce(title: String, description: String,price: String, tel: Bool, day: Bool, night: Bool) {
      
        let idUser = CurrentUserManager.shared.user.senderId
        let latitude = location.latitude
        let longitute = location.longitude
        let coordinate = GeoPoint(latitude: latitude, longitude: longitute)
        let semaine = decodedDataInObject()!
        let announceCreate = Announce(id: "",idUser: idUser , title: title, description: description, price: price, semaine: semaine, coordinate: coordinate, tel: tel, day: day, night: night)
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

   /* func addSemaine(semaine: Semaine, idDocument: String) {
        manageFireBase.addDataSemaine(semaine: semaine, idDocument: idDocument)
    }*/
    
   
}

protocol AnnounceEditDelegate {
    func alert(_ title: String,_ message: String)
}
