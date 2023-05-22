//
//  ModelTests.swift
//  AmigoTests
//
//  Created by Mickaël Horn on 22/05/2023.
//

import XCTest
@testable import Amigo

final class ModelTests: XCTestCase {
    // MARK: - VARIABLES
    private var trip1: Trip!
    private var trip2: Trip!
    private var trip3: Trip!

    
    // MARK: - UTILITIES FUNC
    override func setUp() {
        super.setUp()

        setupTrips()
    }
    
    private func setupTrips() {
        // Sample trips.
        trip1 = Trip(tripID: "1", userID: "user1", startDate: Date(), endDate: Date().addingTimeInterval(3600), country: "France", countryCode: "FR")
        trip2 = Trip(tripID: "2", userID: "user2", startDate: Date(), endDate: Date().addingTimeInterval(7200), country: "Monaco", countryCode: "MC")
        trip3 = Trip(tripID: "3", userID: "user3", startDate: Date(), endDate: Date().addingTimeInterval(1800), country: "Egypt", countryCode: "EG")
    }
    
    // MARK: - UserManagement.swift
    func testGivenWomanGender_WhenGettingIndexOfGender_ThenReturnWomanIndex() {
        let gender = User.Gender.woman
        let indexOfGender = User.Gender.index(of: gender)
        XCTAssertEqual(indexOfGender, 0)
    }

    func testGivenManGender_WhenGettingIndexOfGender_ThenReturnManIndex() {
        let gender = User.Gender.man
        let indexOfGender = User.Gender.index(of: gender)
        XCTAssertEqual(indexOfGender, 1)
    }
    
    func testGivenIncorrectEMail_WhenControllingTheEMail_ThenReturnFalse() {
        XCTAssertFalse(UserManagement.isValidEmail("invalidmail"))
    }
    
    func testGivenCorrectEMail_WhenControllingTheEMail_ThenReturnTrue() {
        XCTAssertTrue(UserManagement.isValidEmail("validmail@test.com"))
    }
    
    func testGivenIncorrectPassword_WhenControllingThePassword_ThenReturnFalse() {
        XCTAssertFalse(UserManagement.isValidPassword("123456"))
    }
    
    func testGivenCorrectPassword_WhenControllingThePassword_ThenReturnTrue() {
        XCTAssertTrue(UserManagement.isValidPassword("lkioKp9"))
    }
    
    func testGivenDifferentPasswords_WhenEqualityCheck_ThenPasswordsAreDifferents() {
        let password = "juh7j"
        let confirmPassword = "ijrge"
        let equalityResult = UserManagement.passwordEqualityCheck(password: password, confirmPassword: confirmPassword)
        
        XCTAssertFalse(equalityResult)
    }
    
    func testGivenSamePasswords_WhenEqualityCheck_ThenPasswordsAreEquals() {
        let password = "juh7j"
        let confirmPassword = "juh7j"
        let equalityResult = UserManagement.passwordEqualityCheck(password: password, confirmPassword: confirmPassword)
        
        XCTAssertTrue(equalityResult)
    }
    
    // MARK: - TripManagement.swift
    func testGivenTripTable_WhenSortingByDates_ThenTripTableIsSorted() {
        let unsortedTrips: [Trip] = [trip1, trip2, trip3]
        let sortedTrips = TripManagement.sortTripsByDateAscending(trips: unsortedTrips)
        
        // Validating the correct ordering of the sorted trip.
        XCTAssertEqual(sortedTrips[0].country, "Egypt")
        XCTAssertEqual(sortedTrips[1].country, "France")
        XCTAssertEqual(sortedTrips[2].country, "Monaco")
    }
}
