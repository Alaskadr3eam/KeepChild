//
//  Announce.swift
//  KeepChild
//
//  Created by Clément Martin on 13/09/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation

struct Announce: Codable {
    var id: String?
    var idUser: String
    var title: String
    var description: String
    var price: String
   
}

struct Adresse: Codable {
    var lat: Int?
    var long: Int?
}

struct AnnounceListData: Codable {
    var announce: [Announce]
}

struct ProfilUser: Codable {
    var iDuser: String
    var nom: String
    var prenom: String
    var pseudo: String
    var tel: Int
  //  var photo: String
}
