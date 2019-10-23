//
//  MapKitAnnounceTest.swift
//  KeepChildTests
//
//  Created by Clément Martin on 15/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import XCTest

@testable import KeepChild

class MapKitAnnounceTest: XCTestCase {
    
    var mapKitAnnounce: MapKitAnnounceGestion!
    override func setUp() {
        mapKitAnnounce = MapKitAnnounceGestion()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testTransformeAnnounceInAnnounceLocation() {
        //Given
        var announce1Location: AnnounceLocation!
        XCTAssertNil(announce1Location)
        //When
        announce1Location = mapKitAnnounce.transformAnnounceIntoAnnounceLocation(announce: announce1)
        //Then
        XCTAssertEqual(announce1Location.title, announce1.title)
        XCTAssertNotNil(announce1Location)
    }

    func testTransformeAnnounceLocationIntoAnnounce() {
        //Given
        var announceTest: Announce!
        guard let announce2Location = mapKitAnnounce.transformAnnounceIntoAnnounceLocation(announce: announce2) else { return }
        XCTAssertNil(announceTest)
        //When
        announceTest = mapKitAnnounce.transformAnnounceLocationIntoAnnounce(announceLoc: announce2Location)
        //Then
        XCTAssertEqual(announceTest.title, announce2Location.title)
        XCTAssertEqual(announceTest, announce2)
        XCTAssertNotNil(announceTest)
    }

    func testFillLoactionAnnounceArray() {
        //Given
        mapKitAnnounce.announceList.append(announce1)
        mapKitAnnounce.announceList.append(announce2)
        XCTAssertEqual(mapKitAnnounce.announceListLocation.count, 0)
        //When
        mapKitAnnounce.toFillTheLocationAnnounceArray()
        //Then
        XCTAssertEqual(mapKitAnnounce.announceListLocation.count, 2)
    }

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

}
