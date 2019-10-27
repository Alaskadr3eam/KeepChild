//
//  ManageConversationTest.swift
//  KeepChildTests
//
//  Created by Clément Martin on 22/10/2019.
//  Copyright © 2019 Clément Martin. All rights reserved.
//

import XCTest
import Firebase

@testable import KeepChild

class ManageConversationTest: XCTestCase {
    
    var manageConversation: ConversationManager!
    var mockDataManager: MockDataManager!
    
    override func setUp() {
        mockDataManager = MockDataManager()
        manageConversation = ConversationManager(firebaseServiceSession: FirebaseService(dataManager: mockDataManager))
        // Put setup code here. This method is called before the invocation of each test method in the class.
        //Given
        //When
        //Then
    }

    func testMessageInDic() {
        //Given
        CurrentUserManager.shared.user = user1
        CurrentUserManager.shared.profil = profil1
        manageConversation.messages.append(message1)
        XCTAssertEqual(manageConversation.messageDict.count, 0)
        //When
        manageConversation.transformeMessageInDic()
        //Then
        XCTAssertEqual(manageConversation.messageDict.count, 1)
        
    }

    func testPrepareSendMessageNoExisting() {
        //Given
        CurrentUserManager.shared.user = user1
        CurrentUserManager.shared.profil = profil1
        manageConversation.announce = announce2
        //let conversation: Conversation!
        let text = "Bonjour test"
        XCTAssertEqual(manageConversation.arrayMessageRep.count, 0)
        XCTAssertEqual(manageConversation.arrayMessage.count, 0)
        XCTAssertNil(manageConversation.newConversation)
        //When
        manageConversation.prepareSendMessage(text: text)
        //Then
        XCTAssertEqual(manageConversation.arrayMessageRep.count, 1)
        XCTAssertEqual(manageConversation.arrayMessage.count, 1)
        XCTAssertNotNil(manageConversation.newConversation)
        XCTAssertNil(manageConversation.conversation)
    }

    func testPrepareSendMessageIsExisting() {
        //Given
        manageConversation.isExisting = true
        CurrentUserManager.shared.user = user1
        CurrentUserManager.shared.profil = profil1
        manageConversation.announce = announce2
        //let conversation: Conversation!
        let text = "Bonjour test"
        XCTAssertEqual(manageConversation.arrayMessageRep.count, 0)
        XCTAssertEqual(manageConversation.arrayMessage.count, 0)
        XCTAssertNil(manageConversation.newConversation)
        //When
        manageConversation.prepareSendMessage(text: text)
        //Then
        XCTAssertEqual(manageConversation.arrayMessageRep.count, 1)
        XCTAssertEqual(manageConversation.arrayMessage.count, 1)
        XCTAssertNil(manageConversation.newConversation)
        
    }
    
    func testCreateOrRetrieveDocumentID() {
        //Given
        CurrentUserManager.shared.user = user1
        CurrentUserManager.shared.profil = profil1
        manageConversation.announce = announce2
        XCTAssertTrue(manageConversation.documentID.isEmpty)
        //When
        manageConversation.createOrRetrieveDocumentID()
        //Then
        XCTAssertFalse(manageConversation.documentID.isEmpty)
        XCTAssertEqual(manageConversation.documentID, "uid1uid22")
    }

    //MARK: - Request
    func testUpdateConversationSuccess() {
        //Given
        CurrentUserManager.shared.user = user1
        CurrentUserManager.shared.profil = profil1
        manageConversation.announce = announce2
        manageConversation.conversation = conversation1
        manageConversation.transformeMessageInDic()
        let arrayMessage = manageConversation.messageDict as Any
        let update = ["message":arrayMessage]
        var boolTest: Bool!
        //When
        manageConversation.updateConversation(update: update) { (bool) in
            guard bool == true else {
                boolTest = bool
                return
            }
            boolTest = bool
        }
        //Then
        XCTAssertEqual(boolTest, true)
    }

    func testUpdateConversationFail() {
        //Given
        mockDataManager.shouldSucceed = false
        CurrentUserManager.shared.user = user1
        CurrentUserManager.shared.profil = profil1
        manageConversation.announce = announce2
        manageConversation.conversation = conversation1
        manageConversation.transformeMessageInDic()
        var boolTest: Bool!
        let arrayMessage = manageConversation.messageDict as Any
        let update = ["message":arrayMessage]
        //When
        manageConversation.updateConversation(update: update) { (bool) in
            guard bool == true else {
                boolTest = bool
                return
            }
            boolTest = bool
        }
        //Then
         XCTAssertEqual(boolTest, false)
    }

    func testRetrieveConversationSuccess() {
        //Given
        var errorTest: Error!
        XCTAssertEqual(manageConversation.arrayConversation.count, 0)
        //When
        manageConversation.retrieveConversion(field: "idUser1") { (error, bool) in
            guard error == nil else {
                errorTest = error
                return
            }
            guard bool == true else {
                return
            }
        }
        //Then
        XCTAssertNil(errorTest)
        XCTAssertEqual(manageConversation.arrayConversation.count, 1)
    }

    func testRetrieveConversationFail() {
        //Given
        mockDataManager.shouldSucceed = false
        var errorTest: Error!
        XCTAssertEqual(manageConversation.arrayConversation.count, 0)
        //When
        manageConversation.retrieveConversion(field: "idUser1") { (error, bool) in
            guard error == nil else {
                errorTest = error
                return
            }
            guard bool == true else {
                return
            }
        }
        //Then
        XCTAssertNotNil(errorTest)
        XCTAssertEqual(manageConversation.arrayConversation.count, 0)
    }

    func testDeleteConversationSuccess() {
        //Given
        let announce = announce1
        var errorTest: Error!
        XCTAssertNil(errorTest)
        XCTAssertEqual(mockDataManager.conversationArray.count, 1)
        //When
        guard let id = announce.id else { return }
        manageConversation.deleteConversation(announceID: id) { (error) in
            guard error == nil else {
                errorTest = error
                return
            }
        }
        //Then
        XCTAssertEqual(mockDataManager.conversationArray.count, 0)
        XCTAssertNil(errorTest)
    }
    
    func testDeleteConversationFail() {
        //Given
        mockDataManager.shouldSucceed = false
        let announce = announce1
        var errorTest: Error!
        XCTAssertNil(errorTest)
        XCTAssertEqual(mockDataManager.conversationArray.count, 1)
        //When
        guard let id = announce.id else { return }
        manageConversation.deleteConversation(announceID: id) { (error) in
            guard error == nil else {
                errorTest = error
                return
            }
        }
        //Then
        XCTAssertEqual(mockDataManager.conversationArray.count, 1)
        XCTAssertNotNil(errorTest)
    }

    func testReadConversationSuccess() {
        //Given
        XCTAssertFalse(manageConversation.isExisting)
        //When
        manageConversation.readConversation()
        //Then
        XCTAssertTrue(manageConversation.isExisting)
    }

    func testReadConversationFail() {
        //Given
        mockDataManager.shouldSucceed = false
        XCTAssertFalse(manageConversation.isExisting)
        //When
        manageConversation.readConversation()
        //Then
        XCTAssertFalse(manageConversation.isExisting)
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
