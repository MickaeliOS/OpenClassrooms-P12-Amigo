//
//  FirebaseMock.swift
//  AmigoTests
//
//  Created by Mickaël Horn on 25/05/2023.
//

import Foundation
import FirebaseAuth
@testable import Amigo

final class FirebaseMock: FirebaseProtocol {
    
    // MARK: - PROPERTIES
    
    // I am verifying that the functions have been triggered to ensure that we did not utilize Firebase.
    var signInTriggered = false
    var signOutTriggered = false
    var createUserTriggered = false
    var saveUserIntDatabaseTriggered = false
    var fetchUserTriggered = false
    var updateUserTriggered = false
    var createTripTriggered = false
    var fetchTripsTriggered = false
    
    // These properties indicate an expectation for the corresponding function to succeed.
    // If set to false, it signifies an intention for them to throw an error.
    var signInSuccess = true
    var signOutSuccess = true
    var createUserSuccess = true
    var saveUserIntDatabaseSuccess = true
    var fetchUserSuccess = true
    var updateUserSuccess = true
    var createTripSuccess = true
    var fetchTripsSuccess = true

    // Errors.
    private let testError = TestError.testError
    var signInError = NSError()
    var createUserError = NSError()
}

extension FirebaseMock {
    
    // MARK: - FUNCTIONS
    func signIn(email: String, password: String) async throws {
        signInTriggered = true
        if !signInSuccess { throw signInError }
    }
    
    func signOut() throws {
        signOutTriggered = true
        if !signOutSuccess { throw testError }
    }
    
    func createUser(withEmail: String, password: String) async throws {
        createUserTriggered = true
        if !createUserSuccess { throw createUserError }
    }
    
    func saveUserInDatabase(userID: String, fields: [String : Any]) async throws {
        saveUserIntDatabaseTriggered = true
        if !saveUserIntDatabaseSuccess { throw testError }
    }
    
    func fetchUser(userID: String) async throws -> Amigo.User? {
        fetchUserTriggered = true
        if !fetchUserSuccess { throw testError }
        return nil
    }
    
    func updateUser(fields: [String : Any], userID: String) async throws {
        updateUserTriggered = true
        if !updateUserSuccess { throw testError }
    }
    
    func createTrip(trip: Trip) throws -> String {
        createTripTriggered = true
        if !createTripSuccess { throw testError }
        return "tripID"
    }
    
    func fetchTrips(userID: String) async throws -> [Trip] {
        fetchTripsTriggered = true
        if !fetchTripsSuccess { throw testError }
        return []
    }
}

// A basic error fot our tests.
final class TestError: Error {
    static let testError = TestError()
}
