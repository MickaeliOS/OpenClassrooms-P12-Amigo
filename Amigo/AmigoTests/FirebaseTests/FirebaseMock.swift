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
    
    // A basic error fot our tests.
    private let testError = TestError.testError
    
    // CreateUser.
    var createUserSuccess = true
    var createUserError = NSError()
    
    // SaveUserInDatabase.
    var saveUserIntDatabaseSuccess = true
    
    func createUser(withEmail: String, password: String) async throws {
        if !createUserSuccess {
            throw createUserError
        }
    }
    
    func saveUserInDatabase(user: Amigo.User, userID: String, fields: [String : Any]) async throws {
        if !saveUserIntDatabaseSuccess {
            throw testError
        }
    }

}

final class TestError: Error {
    static let testError = TestError()
}
