//
//  AnnounceListTest.swift
//  KeepChildTests
//
//  Created by Clément Martin on 15/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import Foundation

import XCTest
import CoreLocation
@testable import KeepChild

class ProfilGestionTest: XCTestCase {
    
    var profilGestion: ProfilGestion!
    var mockDataManger: MockDataManager!

    override func setUp() {
        profilGestion = ProfilGestion()
        mockDataManger = MockDataManager()
        DependencyInjection.shared.dataManager = mockDataManger
        
        user1 = User(senderId: "uid1", email: "email1")
        user2 = User(senderId: "uid2", email: "email2")
    }

    //MARK: - Request for firebase
    func testRetrieveAnnounceUserSuccess() {
        //Given
        var announceTest: [Announce]!
        //When
        profilGestion.retrieveAnnounceUser(field: "idUser", equal: user1.senderId) { (error, announce) in
            guard error == nil else {
                return
            }
            guard announce != nil else {
                return
            }
            announceTest = announce
        }
        //Then
        XCTAssertEqual(announceTest.count, 1)
    }

    func testRetrieveAnnounceUserFail() {
        //Given
        mockDataManger.shouldSucceed = false
        var announceTest: [Announce]!
        var errorTest: Error!
        //When
        profilGestion.retrieveAnnounceUser(field: "idUser", equal: "") { (error, announce) in
            guard error == nil else {
                errorTest = error
                return
            }
            guard announce != nil else {
                return
            }
            announceTest = announce
        }
        //Then
        XCTAssertEqual(announceTest,nil)
        XCTAssertNotNil(errorTest)
    }

    func testRetrieveProfilAnnounceSuccess() {
        //Given
        var profilTest: ProfilUser!
        //When
        profilGestion.retrieveProfilAnnounce(field: "idUser", equal: user1.senderId) { (error, profil) in
            guard error == nil else {
                return
            }
            guard profil != nil else {
                return
            }
            guard let profilSecure = profil else { return }
            let profilUser = profilSecure[0]
            profilTest = profilUser
        }
        //Then
        XCTAssertEqual(profilTest, profil1)
    }

    func testRetrieveProfilAnnounceFail() {
        //Given
        mockDataManger.shouldSucceed = false
        var profilTest: ProfilUser!
        var errorTest: Error!
        //When
        profilGestion.retrieveProfilAnnounce(field: "idUser", equal: "") { (error, profil) in
            guard error == nil else {
                errorTest = error
                return
            }
            guard profil != nil else {
                return
            }
            guard let profilSecure = profil else { return }
            let profilUser = profilSecure[0]
            profilTest = profilUser
        }
        //Then
        XCTAssertNil(profilTest)
        XCTAssertNotNil(errorTest)
    }

    func testAddDataProfilInFirebaseSuccess() {
        //Given
        var boolResult: Bool!
        //When
        profilGestion.addDataProfil(profil: profil1) { (bool) in
            boolResult = bool
        }
        //Then
        XCTAssertTrue(boolResult)
    }
    
    func testAddDataProfilInFirebaseFail() {
        //Given
        mockDataManger.shouldSucceed = false
        var boolResult: Bool!
        //When
        profilGestion.addDataProfil(profil: profil1) { (bool) in
            boolResult = bool
        }
        //Then
        XCTAssertFalse(boolResult)
    }

}
