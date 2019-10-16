//
//  FirestoreTestsCase.swift
//  KeepChildTests
//
//  Created by Clément Martin on 11/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import XCTest
import Firebase
@testable import KeepChild

/*class FirestoreTestsCase: XCTestCase {
    
    var profilGestion: ProfilGestion!

    override func setUp() {
       profilGestion = ProfilGestion()
    }
    
    func createProfilUser() -> ProfilUser {
        let profilUser = ProfilUser(id: nil, iDuser: CurrentUserManager.shared.user.senderId, nom: "Test", prenom: "Testable", pseudo: "TestTest", mail: CurrentUserManager.shared.user.email, tel: 0466630555, postalCode: "34000", city: "Montpellier")
        return profilUser
    }
   /* func createAnnounce() -> Announce {
        let coordinate = GeoPoint(latitude: 1.1, longitude: 1.2)
        let semaine = Semaine(idUser: nil, lundi: true, mardi: true, mercredi: true, jeudi: true, vendredi: true, samedi: true, dimanche: true)
        var announce: Announce?
        
        return announce
    }*/

    func testAddProfilUser() {
        profilGestion.addDataProfil(profil: createProfilUser())
    }
    
  /*  func testAddAnnounce() {
        var boolResult: Bool!
        
        manageFireBaseTest.addData(announce: createAnnounce()) { (bool) in
            guard bool == true else {
                boolResult = false
                return
            }
            boolResult = true
        }
        
        XCTAssertEqual(boolResult, true)
    }*/

    

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}*/


