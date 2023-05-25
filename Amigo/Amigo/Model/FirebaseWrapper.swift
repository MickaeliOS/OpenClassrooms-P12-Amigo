//
//  FirebaseWrapper.swift
//  Amigo
//
//  Created by Mickaël Horn on 25/05/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

// MARK: - PROTOCOL
    // This protocol contains all the functions the project will use.
    // It will be really useful for Mocking Firebase later.
protocol FirebaseProtocol {
    func createUser(withEmail: String, password: String) async throws
    func saveUserInDatabase(user: User, userID: String, fields: [String: Any]) async throws
}

// MARK: - PROTOCOLS
    // Inside the Wrapper, we write the classics Firebase functions.
    // These functions does not need to be tested, because it is already done
    // by Firebase.
final class FirebaseWrapper: FirebaseProtocol {

    func createUser(withEmail: String, password: String) async throws {
        do {
            try await Auth.auth().createUser(withEmail: withEmail, password: password)
        } catch let error {
            throw error
        }
    }
    
    func saveUserInDatabase(user: User, userID: String, fields: [String: Any]) async throws {
        do {
            try await Firestore.firestore().collection(Constant.FirestoreTables.User.tableName).document(userID).setData(fields)

        } catch let error {
            throw error
        }
    }
}
