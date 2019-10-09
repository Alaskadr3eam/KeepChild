//
//  Master.swift
//  KeepChild
//
//  Created by Clément Martin on 28/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import Firebase

class Master {
    var manageFireBase = ManageFireBase()
    var announceList = [Announce]()
    var announceTransition = [Announce]()


    func readData(collection: String, completionHandler: @escaping (Error?,[Announce]?) -> Void) {
        manageFireBase.readDataAnnounce(collection: collection) { [weak self] (error, announceList) in
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
    var day: [String:Bool?] = ["semaine.mercredi":true,
                               "semaine.jeudi": true]
    func testRequestFilter(completionHandler: @escaping(Error?, [Announce]?) -> Void) {
        
        
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
        
    }
    
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
    var filter = ["semaine.mercredi":true,
                  "semaine.jeudi":true]
    func searchAnnounceFiltered(lesserGeopoint: GeoPoint, greaterGeopoint: GeoPoint, completionHandler: @escaping(Error?, [Announce]?) -> Void) {
   
        var arrayAnnounceFinal = [Announce]()
        
      
        manageFireBase.searchAnnounceWithFilter(lesserGeopoint: lesserGeopoint, greaterGeopoint: greaterGeopoint) { [weak self] (error, announceList) in
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
}
