//
//  FilterTest.swift
//  KeepChildTests
//
//  Created by Clément Martin on 20/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import XCTest
@testable import KeepChild

class FilterTest: XCTestCase {
    
    var filterGestion: FilterGestion!
    
    override func setUp() {
        filterGestion = FilterGestion()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testDistanceInMile() {
        //Given
        let value: Float = 1.0
        //When
        filterGestion.distanceInMile(value: value)
        //Then
        XCTAssertEqual(filterGestion.distanceMile, 0.6213727366498067)
    }

    func testDistanceInMeters() {
        //Given
        let value: Float = 1.0
        XCTAssertNil(filterGestion.regionRadius)
        //When
        filterGestion.distanceInMetersForRegionRadiusMapKit(value: value)
        //Then
        XCTAssertEqual(filterGestion.regionRadius, 1000.0)
    }

    func testDistanceForSlider() {
        //Given
        var value: Float!
        filterGestion.filter = filter1
        //When
        value = filterGestion.disTanceForSlider()
        //Then
        XCTAssertEqual(value, 1)
    }

    func testCreateFilterForSearch() {
        //Given
        filterGestion.dayFilter = ["lundi":true]
        filterGestion.momentDay = ["day":true]
        filterGestion.lesserGeopoint = coordinate1
        filterGestion.greaterGeopoint = coordinate2
        filterGestion.regionRadius = 10000
        filterGestion.latChoice = 1.5
        filterGestion.longChoice = 1.2
        filterGestion.profilLocIsSelected = true
        XCTAssertNil(filterGestion.filter)
        //When
        filterGestion.createFilterForSearch()
        //Then
        XCTAssertNotNil(filterGestion.filter)
        XCTAssertEqual(filterGestion.filter.latChoice, 1.5)
    }
    func testPrepareQueryIsPossibleF() {
        //Given
        //When
        let result = filterGestion.prepareQueryIsPossibleOrNot()
        //Then
        XCTAssertFalse(result)
    }

    func testPrepareQueryIsPossibleT() {
        //Given
        filterGestion.distanceMile = 1.6
        filterGestion.latChoice = 1.5
        filterGestion.longChoice = 1.2
        //When
        let result = filterGestion.prepareQueryIsPossibleOrNot()
        //Then
        XCTAssertTrue(result)
    }
    
    func testPrepareQuery() {
        //Given
        filterGestion.distanceMile = 1.6
        filterGestion.latChoice = 1.5
        filterGestion.longChoice = 1.2
        XCTAssertNil(filterGestion.lesserGeopoint)
        XCTAssertNil(filterGestion.greaterGeopoint)
        //When
        filterGestion.prepareQueryLoc()
        //Then
        XCTAssertNotNil(filterGestion.lesserGeopoint)
        XCTAssertNotNil(filterGestion.greaterGeopoint)
        
    }

    func testSearchIsCompleteIsTrue() {
        //Given
        filterGestion.dayFilter = ["lundi":true]
        filterGestion.momentDay = ["day":true]
        filterGestion.lesserGeopoint = coordinate1
        filterGestion.greaterGeopoint = coordinate2
        filterGestion.regionRadius = 10000
        filterGestion.latChoice = 1.5
        filterGestion.longChoice = 1.2
        //When
        let result = filterGestion.filterSearchIsComplete()
        //Then
        XCTAssertTrue(result)
    }

    func testSearchIsCompleteIsFalse1() {
        //Given
        filterGestion.dayFilter = ["lundi":true]
        filterGestion.momentDay = ["day":true]
        filterGestion.lesserGeopoint = coordinate1
        filterGestion.greaterGeopoint = coordinate2
        filterGestion.regionRadius = 10000
        //When
        let result = filterGestion.filterSearchIsComplete()
        //Then
        XCTAssertFalse(result)
    }

    func testSearchIsCompleteIsFalse2() {
        //Given
        filterGestion.dayFilter = ["lundi":true]
        filterGestion.momentDay = ["day":true]
        filterGestion.lesserGeopoint = coordinate1
        filterGestion.greaterGeopoint = coordinate2
        //When
        let result = filterGestion.filterSearchIsComplete()
        //Then
        XCTAssertFalse(result)
    }

    func testSearchIsCompleteIsFalse3() {
        //Given
        filterGestion.dayFilter = ["lundi":true]
        filterGestion.momentDay = ["day":true]
        //When
        let result = filterGestion.filterSearchIsComplete()
        //Then
        XCTAssertFalse(result)
    }

    func testSearchIsCompleteIsFalse4() {
        //Given
        //When
        let result = filterGestion.filterSearchIsComplete()
        //Then
        XCTAssertFalse(result)
    }

    
    
    func testGeocoderSuccess() {
        let expect = expectation(description: "Wait for geocode")
        filterGestion.getCoordinate(addressString: "Infinite Loop 1, Cupertino") { (coordinate, error) in
            defer { expect.fulfill() }
            
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return }
            guard coordinate != nil else {
                XCTFail("No coordinate")
                return }
            guard let location = coordinate else { return }
            
            XCTAssertEqual(location.latitude, 37.3316851, accuracy: 0.001, "Latitude doesn't match")
            XCTAssertEqual(location.longitude, -122.0300674, accuracy: 0.001, "Longitude doesn't match")
        }
        waitForExpectations(timeout: 3, handler: nil)
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
