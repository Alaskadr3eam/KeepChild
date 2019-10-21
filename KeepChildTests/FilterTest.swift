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
        filterGestion.filter = filter
        //When
        value = filterGestion.disTanceForSlider()
        //Then
        XCTAssertEqual(value, 1)
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
