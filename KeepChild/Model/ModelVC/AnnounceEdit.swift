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
    //var manageFireBase = ManageFireBase()
    //var idUser = UserDefaults.standard.string(forKey: "userID")
    var delegate: AnnounceEditDelegate?
    
    var announce: Announce!
    var announceList = [Announce]()
    var announceTransition = [Announce]()
    var announceSearch: [Announce]!
    
    var location: CLLocationCoordinate2D!
    var jour: String!

    var lat: CLLocationCoordinate2D!
    var long: CLLocationCoordinate2D!
    

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
    
    func addData(announce: Announce, completionHandler: @escaping (Bool?) -> Void) {
        DependencyInjection.shared.dataManager.addAnnounce(announce: announce) { (bool) in
            guard bool == true else {
                //self.delegate?.alert("Annonce non envoyé", "Désolé, votre annonce n'a pas pu etre sauvegardée. Vérifiez votre connexion internet.")
                completionHandler(bool)
                return
            }
            //self.delegate?.alert("Annonce envoyé", "Félicitation, votre annonce a été enregistré.")
            completionHandler(bool)
        }
        
       /* manageFireBase.addData(announce: announce) { bool in
            guard bool == true else {
                self.delegate?.alert("Annonce non envoyé", "Désolé, votre annonce n'a pas pu etre sauvegardée. Vérifiez votre connexion internet.")
                return
            }
            self.delegate?.alert("Annonce envoyé", "Félicitation, votre annonce a été enregistré.")
        }*/
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
            guard let location = placemark.location else { return }
            self.location = location.coordinate
            completionHandler(location.coordinate, nil)
        }
    }

    func readData(completionHandler: @escaping (Error?,[Announce]?) -> Void) {
        DependencyInjection.shared.dataManager.readDataAnnounce { [weak self] (error, announceList) in
            guard let self = self else { return }
            guard error == nil else {
                completionHandler(error,nil)
                return
            }
            guard let announce = announceList else { return }
            self.announceList = announce
            
            completionHandler(nil,announce)
        }
    }

    func deleteAnnounce(announceId: String, completionHandler: @escaping(Error?) -> Void) {
        DependencyInjection.shared.dataManager.deleteAnnounce(announceId: announceId) { (error) in
            guard error == nil else {
                completionHandler(error)
                return
            }
            completionHandler(nil)
        }
    }
    
    func searchAnnounceFiltered(lesserGeopoint: GeoPoint, greaterGeopoint: GeoPoint, completionHandler: @escaping(Error?, [Announce]?) -> Void) {
        announceTransition = [Announce]()
        DependencyInjection.shared.dataManager.searchAnnounceWithFilter(lesserGeopoint: lesserGeopoint, greaterGeopoint: greaterGeopoint) { [weak self] (error, announceList) in
            guard let self = self else { return }
            guard error == nil else {
                completionHandler(error,nil)
                return
            }
            guard let announce = announceList else { return }
            for announceD in announce {
                self.announceTransition.append(announceD)
            }
            completionHandler(nil,announceList)
        }
    }
    
    func filteredAnnounce() {
        //filter of the search
        let dayFilter = FilterSearch.shared.dayFilter
        let momentDay = FilterSearch.shared.momentDay
        //var for transition
        var announceWithFilterDay = [Announce]()
        var announceWithAllFilter = [Announce]()
        //boucle for day filter
        for announce in announceTransition {
            if announce.semaine.lundi == dayFilter["lundi"] {
                announceWithFilterDay.append(announce)
            }
            if announce.semaine.mardi == dayFilter["mardi"] {
                announceWithFilterDay.append(announce)
            }
            if announce.semaine.mercredi == dayFilter["mercredi"] {
                announceWithFilterDay.append(announce)
            }
            if announce.semaine.jeudi == dayFilter["jeudi"] {
                announceWithFilterDay.append(announce)
            }
            if announce.semaine.vendredi == dayFilter["vendredi"] {
                announceWithFilterDay.append(announce)
            }
            if announce.semaine.samedi == dayFilter["samedi"] {
                announceWithFilterDay.append(announce)
            }
            if announce.semaine.dimanche == dayFilter["dimanche"] {
                announceWithFilterDay.append(announce)
            }
        }
        //boucle for momentDay filter
        for announce in announceWithFilterDay {
            if announce.day == momentDay["day"] {
                announceWithAllFilter.append(announce)
            }
            if announce.night == momentDay["night"] {
                announceWithAllFilter.append(announce)
            }
        }
        announceList = announceWithAllFilter.removeDuplicates()
    }

    
}

protocol AnnounceEditDelegate {
    func alert(_ title: String,_ message: String)
}
