//
//  JourneyFirestoreTests.swift
//  AmigoTests
//
//  Created by Mickaël Horn on 29/05/2023.
//

import XCTest
@testable import Amigo

final class JourneyFirestoreTests: XCTestCase {
    
    // MARK: - MOCK AND MODEL
    private var firebaseMock: FirebaseMock!
    private var journeyFetchingService: JourneyFetchingService!
    private var journeyUpdateService: JourneyUpdateService!
    private var journeyDeletionService: JourneyDeletionService!
    
    // MARK: - UTILITIES FUNC
    override func setUp() {
        super.setUp()
        firebaseMock = FirebaseMock()
        journeyFetchingService = JourneyFetchingService(firebaseWrapper: firebaseMock)
        journeyUpdateService = JourneyUpdateService(firebaseWrapper: firebaseMock)
        journeyDeletionService = JourneyDeletionService(firebaseWrapper: firebaseMock)
    }
    
    // MARK: - fetchTripJourney TESTS
    func testGivenAnError_WhenFetchingTripJourney_ThenCannotGetDocumentsError() {
        firebaseMock.fetchTripJourneyError = firebaseMock.testError
        
        journeyFetchingService.fetchTripJourney(tripID: "1234") { journey, error in
            XCTAssertTrue(self.firebaseMock.fetchTripJourneyTriggered)
            XCTAssertNotNil(error)
            XCTAssertEqual(error, .cannotGetDocuments)
            XCTAssertEqual(error?.localizedDescription, "We couldn't retrieve your document(s), please try to log in again.")
        }
    }
    
    func testGivenNoError_WhenFetchingTripJourney_ThenOptionnalJourneyIsReturned() {
        journeyFetchingService.fetchTripJourney(tripID: "1234") { journey, error in
            XCTAssertTrue(self.firebaseMock.fetchTripJourneyTriggered)
            XCTAssertNil(error)
            XCTAssertNotNil(journey)
        }
    }
    
    // MARK: - journeyUpdate TESTS
    func testGivenAnError_WhenUpdatingJourney_ThenCannotUpdateDocumentsError() {
        firebaseMock.success = false
        
        XCTAssertThrowsError(try journeyUpdateService.updateJourney(journey: Journey(), for: "1234")) { error in
            guard let databaseError = error as? Errors.DatabaseError else {
                XCTFail("Test failed, expected to be Errors.DatabaseError type.")
                return
            }
            
            XCTAssertTrue(firebaseMock.updateJourneyTriggered)
            XCTAssertEqual(databaseError, .cannotUpdateDocuments)
            XCTAssertEqual(databaseError.localizedDescription, "We couldn't update your document(s), please try again.")
        }
    }
    
    func testGivenNoError_WhenUpdatingJourney_ThenJourneyIsUpdated() {
        XCTAssertNoThrow(try journeyUpdateService.updateJourney(journey: Journey(), for: "1234"))
        XCTAssertTrue(firebaseMock.updateJourneyTriggered)

    }
    
    // MARK: - deleteJourney TESTS
    func testGivenAnError_WhenDeletingJourney_ThenCannotDeleteDocumentsError() async {
        firebaseMock.success = false
        
        do {
            try await journeyDeletionService.deleteJourney(tripID: "1234")
            XCTFail("Test failed, expected to throw but passed.")

        } catch let error as Errors.DatabaseError {
            XCTAssertTrue(firebaseMock.deleteJourneyTriggered)
            XCTAssertEqual(error, .cannotDeleteDocuments)
            XCTAssertEqual(error.localizedDescription, "We couldn't delete your document(s), please try again.")
        } catch {
            XCTFail("Test failed, expected to be Errors.DatabaseError type.")
        }
    }
    
    func testGivenNoError_WhenDeletingJourney_ThenJourneyIsDeleted() async {        
        do {
            try await journeyDeletionService.deleteJourney(tripID: "1234")
            XCTAssertTrue(firebaseMock.deleteJourneyTriggered)

        } catch {
            XCTFail("Test failed, was not expected to throw.")
        }
    }
}
