//
//  UserFirestoreTests.swift
//  AmigoTests
//
//  Created by Mickaël Horn on 25/05/2023.
//

import XCTest
@testable import Amigo

final class UserFirestoreTests: XCTestCase {
    
    // MARK: - MOCK AND MODEL
    private var firebaseMock: FirebaseMock!
    private var userCreationService: UserCreationService!
    private var userFetchingService: UserFetchingService!
    private var userUpdatingService: UserUpdatingService!
    
    // MARK: - PROPERTIES
    private let user = User(email: "test@test.com")
    private let userID = "1234"

    // MARK: - UTILITIES FUNC
    override func setUp() {
        super.setUp()
        firebaseMock = FirebaseMock()
        userCreationService = UserCreationService(firebaseWrapper: firebaseMock)
        userFetchingService = UserFetchingService(firebaseWrapper: firebaseMock)
        userUpdatingService = UserUpdatingService(firebaseWrapper: firebaseMock)
    }
    
    // MARK: - SaveUserInDatabase TESTS
    func testGivenAnError_WhenSavingUser_ThenCannotSaveUserError() async {
        firebaseMock.saveUserIntDatabaseSuccess = false
        
        do {
            try await userCreationService.saveUserInDatabase(user: user, userID: userID)
            XCTFail("Test failed, expected to throw but passed.")

        } catch let error as Errors.DatabaseError {
            XCTAssertEqual(error, .cannotSaveUser)
            XCTAssertEqual(error.localizedDescription, "We couldn't save your informations, please try again.")
        } catch {
            XCTFail("Test failed, expected to be Errors.DatabaseError type.")
        }
    }
    
    func testGivenNoError_WhenSavingUser_ThenUserIsSaved() async {
        do {
            try await userCreationService.saveUserInDatabase(user: user, userID: userID)

        } catch let error as Errors.DatabaseError {
            XCTAssertEqual(error, .cannotSaveUser)
            XCTAssertEqual(error.localizedDescription, "We couldn't save your informations, please try again.")
        } catch {
            XCTFail("Test failed, expected to be Errors.DatabaseError type.")
        }
    }
    
    // MARK: - fetchUser TESTS
    func testGivenAnError_WhenFetchingUser_ThenCannotGetDocumentsError() async {
        firebaseMock.fetchUserSuccess = false
        
        do {
            let _ = try await userFetchingService.fetchUser(userID: userID)
            XCTFail("Test failed, expected to throw but passed.")

        } catch let error as Errors.DatabaseError {
            XCTAssertEqual(error, .cannotGetDocuments)
            XCTAssertEqual(error.localizedDescription, "We couldn't retrieve your document(s), please try to log in again.")
        } catch {
            XCTFail("Test failed, expected to be Errors.DatabaseError type.")
        }
    }
    
    func testGivenNoError_WhenFetchingUser_ThenUserIsFetched() async {
        do {
            let _ = try await userFetchingService.fetchUser(userID: userID)

        } catch {
            XCTFail("Test failed, was not expected to throw.")
        }
    }
    
    // MARK: - updateUser TESTS
    func testGivenAnError_WhenUpdatingUser_ThenCannotUploadDocumentsError() async {
        firebaseMock.updateUserSuccess = false
        
        do {
            try await userUpdatingService.updateUser(fields: ["": ""], userID: userID)
            XCTFail("Test failed, expected to throw but passed.")

        } catch let error as Errors.DatabaseError {
            XCTAssertEqual(error, .cannotUploadDocuments)
            XCTAssertEqual(error.localizedDescription, "We couldn't upload your document(s), please try again.")
        } catch {
            XCTFail("Test failed, expected to be Errors.DatabaseError type.")
        }
    }
    
    func testGivenNoError_WhenUpdatingUser_ThenUserIsUpdated() async {
        do {
            try await userUpdatingService.updateUser(fields: ["": ""], userID: userID)

        } catch {
            XCTFail("Test failed, was not expected to throw.")
        }
    }
}
