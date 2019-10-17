//
//  Master.swift
//  KeepChild
//
//  Created by Clément Martin on 28/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import Firebase

/*class Master {
    //var manageFireBase = ManageFireBase()
    var announceList = [Announce]()
    var announceTransition = [Announce]()


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
        
      /*  manageFireBase.readDataAnnounce(collection: collection) { [weak self] (error, announceList) in
            guard let self = self else { return }
            guard error == nil else {
                completionHandler(error,nil)
                return
            }
            guard let announce = announceList else { return }
            self.announceList = announce
           
            completionHandler(nil,announce)
        }*/
    }
   // var day: [String:Bool?] = ["semaine.mercredi":true,
                             //  "semaine.jeudi": true]
   /* func testRequestFilter(completionHandler: @escaping(Error?, [Announce]?) -> Void) {
        
        
        manageFireBase.searchAnnounceWithFilter { [weak self] (error, announceList) in
            guard let self = self else { return }
            guard error == nil else {
                completionHandler(error,nil)
                return
            }
            guard let announce = announceList else { return }
            self.announceList = announce
            completionHandler(nil,announce)
            
        }
        
    }*/
    
   /* func test2(completionHandler: @escaping(Error?, [Announce]?) -> Void) {
        manageFireBase.testBoucle { (error, announceList) in
            guard error == nil else {
                completionHandler(error,nil)
                return
            }
            guard let announce = announceList else {
                return
            }
            self.announceList = announce
            completionHandler(nil,announce)
        }
    }*/
   /* var filter = ["semaine.mercredi":true,
                  "semaine.jeudi":true]*/
    func searchAnnounceFiltered(lesserGeopoint: GeoPoint, greaterGeopoint: GeoPoint, completionHandler: @escaping(Error?, [Announce]?) -> Void) {
   
        var arrayAnnounceFinal = [Announce]()
        
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
       /* manageFireBase.searchAnnounceWithFilter(lesserGeopoint: lesserGeopoint, greaterGeopoint: greaterGeopoint) { [weak self] (error, announceList) in
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
            }*/
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
 
   /* func searchAnnounceFiltered(searchDay: [String], completionHandler: @escaping(Error?,[Announce]?)->Void) {
        announceList.removeAll()
        var announceTransition = [Announce]()
        manageFireBase.searchAnnounceWithFilter(dayFilter: searchDay) { [weak self] (error, announceList) in
            guard let self = self else { return }
            guard error == nil else {
                completionHandler(error,nil)
                return
            }
            guard let announce = announceList else { return }
            announceTransition = announce
            if searchDay.count > 1 {
                for day in searchDay {
                    for announce in announceTransition {
                        for jour in announce.dayList {
                            if jour == day {
                                if self.announceList.count == 0 {
                                    self.announceList.append(announce)
                                } else {
                                for announceId in self.announceList {
                                    if announceId.id != announce.id {
                                        self.announceList.append(announce)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
            } else {
                self.announceList = announceTransition
            }
            completionHandler(nil,announce)
        }
    }*/
}*/
