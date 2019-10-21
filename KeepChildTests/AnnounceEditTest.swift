//
//  AnnounceTest.swift
//  KeepChildTests
//
//  Created by Clément Martin on 15/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import XCTest
import CoreLocation
@testable import KeepChild

class AnnounceEditTest: XCTestCase {
    
    var announceEdit: AnnounceEdit!
    var mockDataManger: MockDataManager!
    override func setUp() {
        announceEdit = AnnounceEdit()
        mockDataManger = MockDataManager()
        //mockDataManger.shouldSucceed = false
        DependencyInjection.shared.dataManager = mockDataManger
        
        user1 = User(senderId: "uid1", email: "email1")
        user2 = User(senderId: "uid2", email: "email2")
    }

    func testEncodeSemaine() {
        //Given
        announceEdit.removeUserDefaultObject(forkey: "semaine")
        XCTAssertNil(UserDefaults.standard.data(forKey: "semaine"))
        //When
        announceEdit.encodeObjectInData(semaine: semaine1)
        //Then
        XCTAssertNotNil(UserDefaults.standard.data(forKey: "semaine"))
    }
    
    func testDecodeSemaine() {
        //Given
        announceEdit.encodeObjectInData(semaine: semaine1)
        XCTAssertNotNil(UserDefaults.standard.data(forKey: "semaine"))
        //When
        let semaine = announceEdit.decodedDataInObject()
        //Then
        XCTAssertEqual(semaine, semaine1)
    }

    func testDecodeSemaineIfNul() {
        //Given
        announceEdit.removeUserDefaultObject(forkey: "semaine")
        XCTAssertNil(UserDefaults.standard.data(forKey: "semaine"))
        //When
        let semaine = announceEdit.decodedDataInObject()
        //Then
        XCTAssertEqual(semaine, nil)
    }

    func testRemoveSemaine() {
        //Given
        XCTAssertNotNil(UserDefaults.standard.data(forKey: "semaine"))
        //When
        announceEdit.removeUserDefaultObject(forkey: "semaine")
        //Then
        XCTAssertEqual(UserDefaults.standard.data(forKey: "semaine"), nil)
    }
    
    func testCreateAnnounce() {
        //Given
        announceEdit.encodeObjectInData(semaine: semaine1)
        announceEdit.location = CLLocationCoordinate2D(latitude: 1.1, longitude: 1.1)
        XCTAssertNil(announceEdit.announce)
        //When
        announceEdit.createAnnounce(title: "test", description: "testtest", price: "priceTest", tel: true, day: true, night: true)
        //Then
        XCTAssertNotNil(announceEdit.announce)
        XCTAssertEqual(announceEdit.announce.title, "test")
    }
    
    func testTransformeSemaineInString() {
        //Given
        var semaineString: String!
        var semaineString2: String!
        XCTAssertNil(semaineString)
        XCTAssertNil(semaineString2)
        //When
        semaineString = "\(announceEdit.transformateSemaineInString(semaine: semaine1))"
        semaineString2 = "\(announceEdit.transformateSemaineInString(semaine: semaine2))"
        //Then
        XCTAssertEqual(semaineString, "lundi, mardi, mercredi, jeudi, vendredi, samedi, dimanche")
        XCTAssertEqual(semaineString2, "vendredi")
    }

    func testTransformeMomentDayInString() {
        //Given
        var momentString: String!
        var momentString2: String!
        XCTAssertNil(momentString)
        XCTAssertNil(momentString2)
        //When
        momentString = "\(announceEdit.transformeMomentDayInString(announce: announce1))"
        momentString2 = "\(announceEdit.transformeMomentDayInString(announce: announce2))"
        //Then
        XCTAssertEqual(momentString, "Jour")
        XCTAssertEqual(momentString2, "Nuit")
    }
    func testGeocoderSuccess() {
        let expect = expectation(description: "Wait for geocode")
        announceEdit.getCoordinate(addressString: "Infinite Loop 1, Cupertino") { (coordinate, error) in
            defer { expect.fulfill() }
            
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return }
            guard coordinate != nil else {
                XCTFail("No coordinate")
                return }
            
            XCTAssertEqual(coordinate.latitude, 37.3316851, accuracy: 0.001, "Latitude doesn't match")
            XCTAssertEqual(coordinate.longitude, -122.0300674, accuracy: 0.001, "Longitude doesn't match")
        }
        waitForExpectations(timeout: 3, handler: nil)
    }

   /* func testGeocoderFail() {
        let expect = expectation(description: "Wait for geocode")
        announceEdit.getCoordinate(addressString: "abc") { (coordinate, error) in
            defer { expect.fulfill() }
            
            guard error == nil else {
                XCTFail(error!.domain)
                return }
            guard coordinate != nil else {
                XCTFail("No coordinate")
                return }
            
            XCTAssertEqual(coordinate.latitude, 37.3316851, accuracy: 0.001, "Latitude doesn't match")
            XCTAssertEqual(coordinate.longitude, -122.0300674, accuracy: 0.001, "Longitude doesn't match")
        }
        waitForExpectations(timeout: 3, handler: nil)
    }*/
  
    
    //MARK: - Request firebase
    
    func testAddAnnounceSuccess() {
        //Given
        var boolResult: Bool!
        XCTAssertEqual(announceEdit.announce, nil)
        //When
        announceEdit.addData(announce: announce1) { (bool) in
           
            boolResult = bool
        }
        //Then
        XCTAssertTrue(boolResult)
    }

    func testAddAnnounceFailed() {
        //Given
        mockDataManger.shouldSucceed = false
        var boolResult: Bool!
        
        XCTAssertEqual(announceEdit.announce, nil)
        //When
        announceEdit.addData(announce: announce1) { (bool) in
            
            boolResult = bool
        }
        //Then
        XCTAssertFalse(boolResult)
    }

    func testReadAnnounceInFirebaseSuccess() {
        //Given
        var errorTest: Error!
        //When
        announceEdit.readData { (error, announceList) in
            guard error == nil else { errorTest = error; return }
            guard announceList != nil else { return }
        }
        //Then
        XCTAssertEqual(announceEdit.announceList.count, 2)
        XCTAssertNil(errorTest)
    }

    func testReadAnnounceInFirebaseFail() {
        //Given
        mockDataManger.shouldSucceed = false
        var errorTest: Error!
        //When
        announceEdit.readData { (error, announceList) in
            guard error == nil else { errorTest = error; return }
            guard announceList != nil else { return }
        }
        //Then
        XCTAssertEqual(announceEdit.announceList.count, 0)
        XCTAssertNotNil(errorTest)
    }

    func testDeleteAnnounceInFireBaseSuccess() {
        //Given
        let id = "test"
        var errorTest: Error!
        //When
        announceEdit.deleteAnnounce(announceId: id) { (error) in
            errorTest = error
        }
        //Then
        XCTAssertNil(errorTest)
    }

    func testDeleteAnnounceInFireBaseFail() {
        //Given
        mockDataManger.shouldSucceed = false
        let id = "test"
        var errorTest: Error!
        //When
        announceEdit.deleteAnnounce(announceId: id) { (error) in
            errorTest = error
        }
        //Then
        XCTAssertNotNil(errorTest)
    }
    
}

class MockUserDefaults : UserDefaults {
    
    convenience init() {
        self.init(suiteName: "Mock User Defaults")!
    }
    
    override init?(suiteName suitename: String?) {
        UserDefaults().removePersistentDomain(forName: suitename!)
        super.init(suiteName: suitename)
    }
    
}
