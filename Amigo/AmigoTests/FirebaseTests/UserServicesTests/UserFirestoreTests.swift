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

    // MARK: - UTILITIES FUNC
    override func setUp() {
        super.setUp()
        firebaseMock = FirebaseMock()
        userCreationService = UserCreationService(firebaseWrapper: firebaseMock)
        userFetchingService = UserFetchingService(firebaseWrapper: firebaseMock)
        userUpdatingService = UserUpdatingService(firebaseWrapper: firebaseMock)
    }
    
    func testGivenAnError_WhenFetchingUser_ThenCannotGetDocumentsError() async {
        firebaseMock.fetchUserSuccess = false
        
        do {
            let _ = try await userFetchingService.fetchUser(userID: "1234")
            XCTFail("Test failed, expected to throw but passed.")

        } catch let error as Errors.DatabaseError {
            XCTAssertEqual(error, .cannotGetDocuments)
            XCTAssertEqual(error.localizedDescription, "We couldn't retrieve your document(s), please try to log in again.")
        } catch {
            XCTFail("Test failed, expected to be Errors.DatabaseError type.")
        }
    }
}
