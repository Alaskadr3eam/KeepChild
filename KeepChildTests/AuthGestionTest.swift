//
//  AuthGestionTest.swift
//  KeepChildTests
//
//  Created by Clément Martin on 22/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import XCTest
@testable import KeepChild

class AuthGestionTest: XCTestCase {
    var authGestion: AuthGestion!
    var mockDataManager: MockDataManager!
    override func setUp() {
        mockDataManager = MockDataManager()
        authGestion = AuthGestion(firebaseServiceSession: FirebaseService(dataManager: mockDataManager))
        // Put setup code here. This method is called before the invocation of each test method in the class.
        //Given
        //When
        //Then
    }

    func testSignInSuccess() {
        //Given
        CurrentUserManager.shared.user = nil
        XCTAssertNil(CurrentUserManager.shared.user)
        //When
        authGestion.signIn(withEmail: "clement.martin@gmail.com", password: "23059944") { (bool) in
            guard bool == true else {
                return
            }
        }
        //Then
        XCTAssertEqual(CurrentUserManager.shared.user, user1)
    }

    func testSignInFail() {
        //Given
        mockDataManager.shouldSucceed = false
        CurrentUserManager.shared.user = nil
        XCTAssertNil(CurrentUserManager.shared.user)
        //When
        authGestion.signIn(withEmail: "clement.martin@gmail.com", password: "23059944") { (bool) in
            guard bool == true else {
                return
            }
        }
        //Then
        XCTAssertNil(CurrentUserManager.shared.user)
    }

    func testSignOutSuccess() {
        //Given
        XCTAssertNotNil(CurrentUserManager.shared.user)
        //When
        authGestion.signOut { (bool) in
            guard bool == true else {
                return
            }
        }
        //Then
        XCTAssertNil(CurrentUserManager.shared.user)
    }

    func testSignOutFail() {
        //Given
        mockDataManager.shouldSucceed = false
        XCTAssertNotNil(CurrentUserManager.shared.user)
        //When
        authGestion.signOut { (bool) in
            guard bool == true else {
                return
            }
        }
        //Then
        XCTAssertNotNil(CurrentUserManager.shared.user)
    }
    
    func testCreateAccountSuccess() {
        //Given
        CurrentUserManager.shared.user = nil
        XCTAssertNil(CurrentUserManager.shared.user)
        //When
        authGestion.createAccount(email: "test", password: "test") { (bool) in
            guard bool == true else {
                return
            }
        }
        //Then
        XCTAssertNotNil(CurrentUserManager.shared.user)
    }

    func testCreateAccountFail() {
        //Given
        mockDataManager.shouldSucceed = false
        CurrentUserManager.shared.user = nil
        XCTAssertNil(CurrentUserManager.shared.user)
        //When
        authGestion.createAccount(email: "test", password: "test") { (bool) in
            guard bool == true else {
                return
            }
        }
        //Then
        XCTAssertNil(CurrentUserManager.shared.user)
        
    }

    func testRetrieveUserSuccess() {
        //Given
        CurrentUserManager.shared.user = nil
        XCTAssertNil(CurrentUserManager.shared.user)
        //When
        authGestion.retrievUserConnected { (bool) in
            guard bool == true else {
                return
            }
        }
        //Then
        XCTAssertNotNil(CurrentUserManager.shared.user)
    }
    
    func testRetrieveUserFail() {
        //Given
        mockDataManager.shouldSucceed = false
        CurrentUserManager.shared.user = nil
        XCTAssertNil(CurrentUserManager.shared.user)
        //When
        authGestion.retrievUserConnected { (bool) in
            guard bool == true else {
                return
            }
        }
        //Then
        XCTAssertNil(CurrentUserManager.shared.user)
        
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
