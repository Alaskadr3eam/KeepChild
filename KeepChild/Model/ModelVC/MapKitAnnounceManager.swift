//
//  MapKitAnnounce.swift
//  KeepChild
//
//  Created by Clément Martin on 19/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import MapKit
import Firebase

class MapKitAnnounceManager {
    //MARK: - Properties
    var announceDetail: Announce?
    var filter: Filter?
    var announceDetailLocation: AnnounceLocation?
    var announceList = [Announce]()
    var announceListLocation = [AnnounceLocation]()
    
    
    //MARK: - Func Helpers
    ///func for fill announcelistlocation
    func toFillTheLocationAnnounceArray() {
        for announce in announceList {
            guard let announceLoc = transformAnnounceIntoAnnounceLocation(announce: announce) else { return }
            announceListLocation.append(announceLoc)
        }
    }
    //func used for mapKitViewController and DetailViewController
    ///func for transformate announce into announceLocation
    func transformAnnounceIntoAnnounceLocation(announce: Announce) -> AnnounceLocation? {
        let latitude = announce.coordinate.latitude
        let longitude = announce.coordinate.longitude
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        guard let id = announce.id else { return nil }
        let tel = announce.phone
        let semaine = announce.semaine
        let day = announce.day
        let night = announce.night
        let announceLoc = AnnounceLocation(id: id, idUser: announce.idUser, title: announce.title, descriptionAnnounce: announce.description, price: announce.price, coordinate: coordinate, tel: tel, semaine: semaine, day: day, night: night)
        return announceLoc
    }
    ///func for transformate announceLoction into announce
    func transformAnnounceLocationIntoAnnounce(announceLoc: AnnounceLocation) -> Announce? {
        let latitude = announceLoc.coordinate.latitude
        let longitude = announceLoc.coordinate.longitude
        guard let title = announceLoc.title else { return nil }
        let coordinate = GeoPoint(latitude: latitude, longitude: longitude)
        let tel = announceLoc.phone
        let semaine = announceLoc.week
        let night = announceLoc.night
        let day = announceLoc.day
        let announce = Announce(id: announceLoc.id, idUser: announceLoc.idUser, title: title, description: announceLoc.descriptionAnnounce, price: announceLoc.price,semaine: semaine, coordinate: coordinate, phone: tel, day: day ,night: night)
        return announce
    }
}
