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
    private let testError = TestError.testError
    
    // SignIn and Out.
    var signInSuccess = true
    var signOutSuccess = true
    var signInError = NSError()

    // CreateUser.
    var createUserSuccess = true
    var createUserError = NSError()
    
    // SaveUserInDatabase.
    var saveUserIntDatabaseSuccess = true
    
    // FetchUser
    var fetchUserSuccess = true
    
    // UpdateUser
    var updateUserSuccess = true
}

extension FirebaseMock {
    
    // MARK: - FUNCTIONS
    func signIn(email: String, password: String) async throws {
        if !signInSuccess { throw signInError }
    }
    
    func signOut() throws {
        if !signOutSuccess { throw testError }
    }
    
    func createUser(withEmail: String, password: String) async throws {
        if !createUserSuccess { throw createUserError }
    }
    
    func setData(user: Amigo.User, userID: String, fields: [String : Any]) async throws {
        if !saveUserIntDatabaseSuccess {
            throw testError
        }
    }
    
    func saveUserInDatabase(user: Amigo.User, userID: String, fields: [String : Any]) async throws {
        print("todo")
    }
    
    func fetchUser(userID: String) async throws -> Amigo.User? {
        if !fetchUserSuccess { throw testError }
        return User(email: "test@test.com")
    }
    
    func updateUser(fields: [String : Any], userID: String) async throws {
        if !updateUserSuccess { throw testError }
    }
}

// A basic error fot our tests.
final class TestError: Error {
    static let testError = TestError()
}
