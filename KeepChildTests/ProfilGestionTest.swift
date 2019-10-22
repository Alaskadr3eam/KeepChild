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
    var mockDataManager: MockDataManager!

    override func setUp() {
        mockDataManager = MockDataManager()
        profilGestion = ProfilGestion(firebaseServiceSession: FirebaseService(dataManager: mockDataManager))
        //mockDataManger = MockDataManager()
        //DependencyInjection.shared.dataManager = mockDataManger
        
        user1 = User(senderId: "uid1", email: "email1")
        user2 = User(senderId: "uid2", email: "email2")
    }
    //MARK: - Helpers Func
    func testTransformateDateInString() {
        //Given
        let isoDate = "2016-04-14T10:44:00+0000"
        let dateFormatter = ISO8601DateFormatter()
        profilGestion.lastConnexion = dateFormatter.date(from:isoDate)!
        var dateString: String!
        //When
        dateString = profilGestion.transformeDateInString()
        //Then
        XCTAssertEqual(dateString, "14-Apr-2016")
    }
    //MARK: - Request for firebase
    func testRetrieveAnnounceUserSuccess() {
        //Given
        XCTAssertEqual(profilGestion.arrayProfilAnnounce.count, 0)
        //When
        profilGestion.retrieveAnnounceUser(field: "idUser", equal: user1.senderId) { (error, announce) in
            guard error == nil else {
                return
            }
            guard announce != nil else {
                return
            }
        }
        //Then
        XCTAssertEqual(profilGestion.arrayProfilAnnounce.count, 1)
        XCTAssertEqual(profilGestion.arrayProfilAnnounce[0], announce1)
    }

    func testRetrieveAnnounceUserFail() {
        //Given
        mockDataManager.shouldSucceed = false
        XCTAssertEqual(profilGestion.arrayProfilAnnounce.count, 0)
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
        }
        //Then
        XCTAssertEqual(profilGestion.arrayProfilAnnounce.count, 0)
        XCTAssertNotNil(errorTest)
    }

    func testRetrieveProfilAnnounceSuccess() {
        //Given
        XCTAssertNil(profilGestion.profil)
        //When
        profilGestion.retrieveProfilAnnounce(field: "idUser", equal: user1.senderId) { (error, profil) in
            guard error == nil else {
                return
            }
            guard profil != nil else {
                return
            }
            //guard profil != nil else { return }

        }
        //Then
        XCTAssertEqual(profilGestion.profil, profil1)
    }

    func testRetrieveProfilAnnounceFail() {
        //Given
        mockDataManager.shouldSucceed = false
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
        }
        //Then
        XCTAssertNil(profilGestion.profil)
        XCTAssertNotNil(errorTest)
    }

    func testRetrieveProfilUserSuccess() {
        //Given
        var errorTest: Error!
        let idUser = CurrentUserManager.shared.user.senderId
        //When
        profilGestion.retrieveProfilUser(field: "idUser", equal: idUser) { (error) in
            guard error == nil else {
                errorTest = error
                return
            }
            
        }
        //Then
        XCTAssertEqual(CurrentUserManager.shared.profil, profil1)
        XCTAssertNil(errorTest)
    }

    func testRetrieveProfilUserFail() {
        //Given
        mockDataManager.shouldSucceed = false
        var errorTest: Error!
        let idUser = CurrentUserManager.shared.user.senderId
        //When
        profilGestion.retrieveProfilUser(field: "idUser", equal: idUser) { (error) in
            guard error == nil else {
                errorTest = error
                return
            }
            
        }
        //Then
        XCTAssertNotEqual(CurrentUserManager.shared.profil, profil1)
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
        mockDataManager.shouldSucceed = false
        var boolResult: Bool!
        //When
        profilGestion.addDataProfil(profil: profil1) { (bool) in
            boolResult = bool
        }
        //Then
        XCTAssertFalse(boolResult)
    }

    func testUpdateProfilSuccess() {
        //Given
        var boolResult: Bool!
        profilGestion.postalCode = "34570"
        profilGestion.city = "murviel-les-montpellier"
        let update: [String: Any] = [
            "name": "Martin" as Any,
            "prenom": "Clément" as Any,
            "telInt": 0466630555 as Any,
            "pseudo": "clemclem" as Any,
            "idUser": user1.senderId as Any,
            "postalCode": profilGestion.postalCode,
            "ville": profilGestion.city
        ]
        guard let id = profil1.id else { return }
        //When
        profilGestion.updateProfil(documentID: id, update: update) { (bool) in
            boolResult = bool
        }
        //Then
        XCTAssertTrue(boolResult)
    }

    func testUpdateProfilFail() {
        //Given
        mockDataManager.shouldSucceed = false
        var boolResult: Bool!
        profilGestion.postalCode = "34570"
        profilGestion.city = "murviel-les-montpellier"
        let update: [String: Any] = [
            "name": "Martin" as Any,
            "prenom": "Clément" as Any,
            "telInt": 0466630555 as Any,
            "pseudo": "clemclem" as Any,
            "idUser": user1.senderId as Any,
            "postalCode": profilGestion.postalCode,
            "ville": profilGestion.city
        ]
        guard let id = profil1.id else { return }
        //When
        profilGestion.updateProfil(documentID: id, update: update) { (bool) in
            boolResult = bool
        }
        //Then
        XCTAssertFalse(boolResult)
    }

    func testUploadPhotoProfilSuccess() {
        //Given
        let data = Data()
        var errorTest: Error!
        //When
        profilGestion.uploadPhotoProfil(imageData: data) { (error, metadata) in
            guard error == nil else {
                errorTest = error
                return
            }
            errorTest = error
        }
        //Then
        XCTAssertNil(errorTest)
    }
    
    func testUploadPhotoProfilFail() {
        //Given
        mockDataManager.shouldSucceed = false
        let data = Data()
        var errorTest: Error!
        //When
        profilGestion.uploadPhotoProfil(imageData: data) { (error, metadata) in
            guard error == nil else {
                errorTest = error
                return
            }
            errorTest = error
        }
        //Then
        XCTAssertNotNil(errorTest)
    }

}
