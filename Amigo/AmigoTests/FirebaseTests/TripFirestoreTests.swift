//
//  TripFirestoreTests.swift
//  AmigoTests
//
//  Created by Mickaël Horn on 26/05/2023.
//

import XCTest
import FirebaseFirestore
@testable import Amigo

final class TripFirestoreTests: XCTestCase {

    // MARK: - MOCK AND MODEL
    private var firebaseMock: FirebaseMock!
    private var tripCreationService: TripCreationService!
    private var tripFetchingService: TripFetchingService!
    private var tripUpdatingService: TripUpdatingService!
    private var tripDeletionService: TripDeletionService!

    // MARK: - PROPERTIES
    private let trip = Trip(userID: "1234", startDate: Date.now, endDate: Date.now, country: "France", countryCode: "FR")
    
    // MARK: - UTILITIES FUNC
    override func setUp() {
        super.setUp()
        firebaseMock = FirebaseMock()
        tripCreationService = TripCreationService(firebaseWrapper: firebaseMock)
        tripFetchingService = TripFetchingService(firebaseWrapper: firebaseMock)
        tripUpdatingService = TripUpdatingService(firebaseWrapper: firebaseMock)
        tripDeletionService = TripDeletionService(firebaseWrapper: firebaseMock)
    }
    
    // MARK: - createTrip TESTS
    func testGivenAnError_WhenCreatingTrip_ThenDefaultError() {
        firebaseMock.success = false
        
        XCTAssertThrowsError(try tripCreationService.createTrip(trip: trip)) { error in
            guard let databaseError = error as? Errors.DatabaseError else {
                XCTFail("Test failed, expected to be Errors.DatabaseError type.")
                return
            }
            
            XCTAssertTrue(firebaseMock.createTripTriggered)
            XCTAssertEqual(databaseError, .defaultError)
            XCTAssertEqual(databaseError.localizedDescription, "A database error occurred, please try again.")
        }
    }
    
    func testGivenNoError_WhenCreatingTrip_ThenTripIsCreated() {
        do {
            let tripID = try tripCreationService.createTrip(trip: trip)
            XCTAssertTrue(firebaseMock.createTripTriggered)
            XCTAssertNotNil(tripID)

        } catch {
            XCTFail("Test failed, was not expected to throw.")
        }
    }

    // MARK: - fetchTrips TESTS
    func testGivenAnError_WhenFetchingTrips_ThenDefaultError() async {
        firebaseMock.success = false
        
        do {
            let _ = try await tripFetchingService.fetchTrips(userID: "1234")
            XCTFail("Test failed, expected to throw but passed.")

        } catch let error as Errors.DatabaseError {
            XCTAssertTrue(firebaseMock.fetchTripsTriggered)
            XCTAssertEqual(error, .cannotGetDocuments)
            XCTAssertEqual(error.localizedDescription, "We couldn't retrieve your document(s), please try to log in again.")
        } catch {
            XCTFail("Test failed, expected to be Errors.DatabaseError type.")
        }
    }
    
    func testGivenNoError_WhenFetchingTrips_ThenTripsAreFetched() async {
        do {
            let _ = try await firebaseMock.fetchTrips(userID: "1234")
            XCTAssertTrue(firebaseMock.fetchTripsTriggered)
        } catch {
            XCTFail("Test failed, was not expected to throw.")
        }
    }
    
    // MARK: - updateTrip TESTS
    func testGivenDocumentNotFound_WhenUpdatingTrip_ThenNotFoundError() async {
        firebaseMock.success = false
        let errorCode = FirestoreErrorCode.notFound.rawValue
        firebaseMock.testNSError = NSError(domain: "", code: errorCode, userInfo: nil)
        
        do {
            try await tripUpdatingService.updateTrip(with: "1234", fields: ["":""])
            XCTFail("Test failed, expected to throw but passed.")

        } catch let error as Errors.DatabaseError {
            XCTAssertTrue(firebaseMock.updateTripTriggered)
            XCTAssertEqual(error, .notFoundUpdate)
            XCTAssertEqual(error.localizedDescription, "The document you are trying to update was not found.")
        } catch {
            XCTFail("Test failed, expected to be Errors.DatabaseError type.")
        }
    }
    
    func testGivenAnNSError_WhenUpdatingTrip_ThenCannotUpdateDocumentsError() async {
        firebaseMock.success = false
        
        do {
            try await tripUpdatingService.updateTrip(with: "1234", fields: ["":""])
            XCTFail("Test failed, expected to throw but passed.")

        } catch let error as Errors.DatabaseError {
            XCTAssertTrue(firebaseMock.updateTripTriggered)
            XCTAssertEqual(error, .cannotUpdateDocuments)
            XCTAssertEqual(error.localizedDescription, "We couldn't update your document(s), please try again.")
        } catch {
            XCTFail("Test failed, expected to be Errors.DatabaseError type.")
        }
    }
    
    func testGivenNoError_WhenUpdatingTrip_ThenTripIsUpdated() async {
        do {
            try await tripUpdatingService.updateTrip(with: "1234", fields: ["":""])
            XCTAssertTrue(firebaseMock.updateTripTriggered)

        } catch {
            XCTFail("Test failed, was not expected to throw.")
        }
    }
    
    // MARK: - deleteTrip TESTS
    func testGivenAnError_WhenDeletingTrip_ThenCannotDeleteDocumentsError() async {
        firebaseMock.success = false
        
        do {
            try await tripDeletionService.deleteTrip(tripID: "1234")
            XCTFail("Test failed, expected to throw but passed.")

        } catch let error as Errors.DatabaseError {
            XCTAssertTrue(firebaseMock.deleteTripTriggered)
            XCTAssertEqual(error, .cannotDeleteDocuments)
            XCTAssertEqual(error.localizedDescription, "We couldn't delete your document(s), please try again.")
        } catch {
            XCTFail("Test failed, expected to be Errors.DatabaseError type.")
        }
    }
    
    func testGivenNoError_WhenDeletingTrip_ThenTripIsDeleted() async {
        do {
            try await tripDeletionService.deleteTrip(tripID: "1234")
            XCTAssertTrue(firebaseMock.deleteTripTriggered)

        } catch {
            XCTFail("Test failed, was not expected to throw.")
        }
    }
}
