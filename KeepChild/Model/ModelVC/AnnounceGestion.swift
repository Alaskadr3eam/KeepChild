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


class AnnounceGestion {
    //MARK: - Properties
    private var firebaseServiceSession = FirebaseService(dataManager: ManagerFirebase())
    
    init(firebaseServiceSession: FirebaseService) {
        self.firebaseServiceSession = firebaseServiceSession
    }
    
    var filter: Filter!
    var announce: Announce!
    var announceList: [Announce]!
    var announceTransition = [Announce]()
    //for core location
    var location: CLLocationCoordinate2D!
    
    //MARK: - Func for UserDefault
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
    //MARK: - Request firebase
    func addData(announce: Announce, completionHandler: @escaping (Bool?) -> Void) {
        firebaseServiceSession.dataManager.addAnnounce(announce: announce) { (bool) in
            guard bool == true else {
                completionHandler(bool)
                return
            }
            completionHandler(bool)
        }
    }
    
    func readData(completionHandler: @escaping (Error?,[Announce]?) -> Void) {
        firebaseServiceSession.dataManager.readDataAnnounce { [weak self] (error, announceList) in
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
        firebaseServiceSession.dataManager.deleteAnnounce(announceId: announceId) { (error) in
            guard error == nil else {
                completionHandler(error)
                return
            }
            completionHandler(nil)
        }
    }
    
    func searchAnnounceFiltered(lesserGeopoint: GeoPoint, greaterGeopoint: GeoPoint, completionHandler: @escaping(Error?, [Announce]?) -> Void) {
        announceTransition = [Announce]()
        firebaseServiceSession.dataManager.searchAnnounceWithFilter(lesserGeopoint: lesserGeopoint, greaterGeopoint: greaterGeopoint) { [weak self] (error, announceList) in
            guard let self = self else { return }
            guard error == nil else {
                completionHandler(error,nil)
                return
            }
            guard let announce = announceList else { return }
            for announceD in announce {
                self.announceTransition.append(announceD)
            }
            self.filteredAnnounce()
            completionHandler(nil,self.announceList)
        }
    }
    //MARK: - Func Geocoder
    func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D?, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            guard error == nil else {
                completionHandler(nil, error as NSError?)
                return
            }
            guard let placemark = placemarks?[0] else { return }
            guard let location = placemark.location else { return }
            self.location = location.coordinate
            completionHandler(location.coordinate, nil)
        }
    }
    //MARK: - Func Helpers
    func createAnnounce(title: String, description: String,price: String, tel: Bool, day: Bool, night: Bool) {
        let idUser = CurrentUserManager.shared.user.senderId
        let latitude = location.latitude
        let longitute = location.longitude
        let coordinate = GeoPoint(latitude: latitude, longitude: longitute)
        let semaine = decodedDataInObject()!
        let announceCreate = Announce(id: "",idUser: idUser , title: title, description: description, price: price, semaine: semaine, coordinate: coordinate, tel: tel, day: day, night: night)
        announce = announceCreate
    }
    
    func filteredAnnounce() {
        //filter of the search
        let dayFilter = filter.dayFilter
        let momentDay = filter.momentDay
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
    
    func transformateSemaineInString(semaine: Semaine) -> String {
        var stringDay = String()
        stringDay += semaineDayIsTrue(semaineDay: semaine.lundi!, day:"lundi, ")
        stringDay += semaineDayIsTrue(semaineDay: semaine.mardi!, day:"mardi, ")
        stringDay += semaineDayIsTrue(semaineDay: semaine.mercredi!, day:"mercredi, ")
        stringDay += semaineDayIsTrue(semaineDay: semaine.jeudi!, day:"jeudi, ")
        stringDay += semaineDayIsTrue(semaineDay: semaine.vendredi!, day:"vendredi, ")
        stringDay += semaineDayIsTrue(semaineDay: semaine.samedi!, day:"samedi, ")
        stringDay += semaineDayIsTrue(semaineDay: semaine.dimanche!, day:"dimanche, ")
        stringDay.removeLast(2)
        return stringDay
    }
    
    private func semaineDayIsTrue(semaineDay: Bool, day: String) -> String {
        var stringDay = String()
        if semaineDay == true {
            stringDay = day
        }
        return stringDay
    }
    
    func transformeMomentDayInString(announce: Announce) -> String {
        var stringMoment = String()
        stringMoment += momentDayIsTrue(momentDay: announce.day, stringMomentDay: "Jour ")
        stringMoment += momentDayIsTrue(momentDay: announce.night, stringMomentDay: "Nuit ")
        stringMoment.removeLast()
        return stringMoment
    }
    
    private func momentDayIsTrue(momentDay: Bool, stringMomentDay: String) -> String {
        var stringMoment = String()
        if momentDay == true {
            stringMoment = stringMomentDay
        }
        return stringMoment
    }
}

