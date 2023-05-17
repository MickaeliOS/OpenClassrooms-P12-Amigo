//
//  UserFetchingService.swift
//  Amigo
//
//  Created by Mickaël Horn on 26/04/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserFetchingService {
    // MARK: - PROPERTIES & INIT
    private let userTableConstants = Constant.FirestoreTables.User.self
    private let firestoreDatabase: Firestore

    init(firestoreDatabase: Firestore = Firestore.firestore()) {
        self.firestoreDatabase = firestoreDatabase
    }
    
    // MARK: - FUNCTIONS
    func fetchUser(userID: String) async throws -> User? {
        do {
            let userTableRef = firestoreDatabase.collection(userTableConstants.tableName).document(userID)
            
            // First, we ensure the existence of the user before proceeding.
            let documentSnapshot = try await userTableRef.getDocument()
            guard documentSnapshot.exists else {
                return nil
            }
            
            // If the user is found, we proceed with decoding and returning the corresponding user object.
            let user = try documentSnapshot.data(as: User.self)
            return user
        } catch {
            throw Errors.DatabaseError.cannotGetDocuments
        }
    }
}
