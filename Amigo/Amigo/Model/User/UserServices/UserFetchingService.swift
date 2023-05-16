//
//  UserFetchingService.swift
//  Amigo
//
//  Created by Mickaël Horn on 26/04/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class UserFetchingService {
    // MARK: - PROPERTIES & INIT
    private let userTableConstants = Constant.FirestoreTables.User.self
    private let firestoreDatabase: Firestore
    private let firebaseAuth: Auth

    init(firestoreDatabase: Firestore = Firestore.firestore(), firebaseAuth: Auth = Auth.auth()) {
        self.firestoreDatabase = firestoreDatabase
        self.firebaseAuth = firebaseAuth
    }
    
    // MARK: - FUNCTIONS
    func fetchUser(userID: String) async throws -> User {
        do {
            let userTableRef = firestoreDatabase.collection(userTableConstants.tableName).document(userID)
            let user = try await userTableRef.getDocument(as: User.self)
            return user
        } catch {
            throw Errors.DatabaseError.cannotGetDocuments
        }
    }
}
