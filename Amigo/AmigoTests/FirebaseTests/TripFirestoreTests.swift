//
//  TripFirestoreTests.swift
//  AmigoTests
//
//  Created by Mickaël Horn on 26/05/2023.
//

import XCTest
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
        /*tripUpdatingService = TripUpdatingService(firebaseWrapper: firebaseMock)
        tripDeletionService = TripDeletionService(firebaseWrapper: firebaseMock)*/
    }
    
    // MARK: - createTrip TESTS
    func testGivenAnError_WhenCreatingTrip_ThenDefaultError() {
        firebaseMock.createTripSuccess = false
        
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
        firebaseMock.fetchTripsSuccess = false
        
        do {
            
        }
    }
}
