//
//  MockObject.swift
//  KeepChildTests
//
//  Created by Clément Martin on 14/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation
import Firebase

@testable import KeepChild

var user1 = User(senderId: "uid1", email: "email1")
var user2 = User(senderId: "uid2", email: "email2")

var profil1 = ProfilUser(id: nil, iDuser: user1.senderId, nom: "numero1", prenom: "1", pseudo: "test1", mail: user1.email, tel: 1111111111, postalCode: "34570", city: "murviel-les-montpellier")
var profil2 = ProfilUser(id: nil, iDuser: user2.senderId, nom: "numero2", prenom: "2", pseudo: "test2", mail: user2.email, tel: 2222222222, postalCode: "34570", city: "montarnaud")

let semaine1 = Semaine(idUser: user1.senderId, lundi: true, mardi: true
    , mercredi: true, jeudi: true, vendredi: true, samedi: true, dimanche: true)
let semaine2 = Semaine(idUser: user2.senderId, lundi: false, mardi: false, mercredi: false, jeudi: false, vendredi: true, samedi: false, dimanche: false)

let coordinate1 = GeoPoint(latitude: 1.1, longitude: 1.2)
let coordinate2 = GeoPoint(latitude: 1.4, longitude: 2.4)

let announce1 = Announce(id: "1", idUser: user1.senderId, title: "announce1", description: "announce1Description", price: "price1", semaine: semaine1, coordinate: coordinate1, tel: true, day: true, night: false)
let announce2 = Announce(id: "2", idUser: user2.senderId, title: "announce2", description: "announce2Description", price: "price2", semaine: semaine2, coordinate: coordinate2, tel: false, day: false, night: true)
