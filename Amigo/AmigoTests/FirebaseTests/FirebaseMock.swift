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
    var updateTripTriggered = false
    var deleteTripTriggered = false
    var fetchTripJourneyTriggered = false
    var updateJourneyTriggered = false
    var deleteJourneyTriggered = false
    var updateExpenseTriggered = false
    var fetchTripExpensesTriggered = false
    var deleteExpenseTriggered = false
    
    // This property indicate an expectation for the corresponding function to succeed.
    // If set to false, it signifies an intention for it to throw an error.
    var success = true

    // Errors.
    let testError = TestError.testError
    var testNSError = NSError()
    var fetchTripJourneyError: Error?
    var fetchTripExpensesError: Error?
}

extension FirebaseMock {
    
    // MARK: - USER AUTH FUNCTIONS
    func signIn(email: String, password: String) async throws {
        signInTriggered = true
        if !success { throw testNSError }
    }
    
    func signOut() throws {
        signOutTriggered = true
        if !success { throw testError }
    }
    
    func createUser(withEmail: String, password: String) async throws {
        createUserTriggered = true
        if !success { throw testNSError }
    }
    
    // MARK: - USER FIRESTORE FUNCTIONS
    func saveUserInDatabase(userID: String, fields: [String : Any]) async throws {
        saveUserIntDatabaseTriggered = true
        if !success { throw testError }
    }
    
    func fetchUser(userID: String) async throws -> Amigo.User? {
        fetchUserTriggered = true
        if !success { throw testError }
        return nil
    }
    
    func updateUser(fields: [String : Any], userID: String) async throws {
        updateUserTriggered = true
        if !success { throw testNSError }
    }
    
    // MARK: - TRIP FIRESTORE FUNCTIONS
    func createTrip(trip: Trip) throws -> String {
        createTripTriggered = true
        if !success { throw testError }
        return "tripID"
    }
    
    func fetchTrips(userID: String) async throws -> [Trip] {
        fetchTripsTriggered = true
        if !success { throw testError }
        return []
    }
    
    func updateTrip(with tripID: String, fields: [String : Any]) async throws {
        updateTripTriggered = true
        if !success { throw testNSError }
    }
    
    func deleteTrip(tripID: String) async throws {
        deleteTripTriggered = true
        if !success { throw testError }
    }
    
    // MARK: - JOURNEY FIRESTORE FUNCTIONS
    func fetchTripJourney(tripID: String, completion: @escaping (Journey?, Error?) -> Void) {
        fetchTripJourneyTriggered = true
        
        let location = Location(address: "Address",
                                postalCode: "90000",
                                city: "City",
                                startDate: Date(timeIntervalSince1970: 1685359786),
                                endDate: Date(timeIntervalSince1970: 1685359786))
        
        completion(Journey(locations: [location]), fetchTripJourneyError)
    }
    
    func updateJourney(journey: Journey, for tripID: String) throws {
        updateJourneyTriggered = true
        if !success { throw testError }
    }
    
    func deleteJourney(tripID: String) async throws {
        deleteJourneyTriggered = true
        if !success { throw testError }
    }
    
    // MARK: - JOURNEY FIRESTORE FUNCTIONS
    func updateExpense(expenses: Expense, for tripID: String) throws {
        updateExpenseTriggered = true
        if !success { throw testError }
    }
    
    func fetchTripExpenses(tripID: String, completion: @escaping (Expense?, Error?) -> Void) {
        fetchTripExpensesTriggered = true
        completion(Expense(expenseItems: [ExpenseItem(title: "Pizza",
                                                      amount: 12,
                                                      date: Date(timeIntervalSince1970: 1685359786))]), fetchTripExpensesError)
    }
    
    func deleteExpense(tripID: String) async throws {
        deleteExpenseTriggered = true
        if !success { throw testError }
    }
}

// A basic error fot our tests.
final class TestError: Error {
    static let testError = TestError()
}
