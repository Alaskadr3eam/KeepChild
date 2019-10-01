//
//  Master.swift
//  KeepChild
//
//  Created by Clément Martin on 28/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation

class Master {
    var manageFireBase = ManageFireBase()
    var announceList = [Announce]()

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
    
    func searchAnnounceFiltered(dayFilter: String, boolFilter: Bool, completionHandler: @escaping(Error?, [Announce]?) -> Void) {
        manageFireBase.searchAnnounceWithFilter(dayFilter: dayFilter, boolFilter: boolFilter) { [weak self] (error, announceList) in
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
