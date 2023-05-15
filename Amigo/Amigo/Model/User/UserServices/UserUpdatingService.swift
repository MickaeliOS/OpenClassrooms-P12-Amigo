//
//  UserUpdatingService.swift
//  Amigo
//
//  Created by Mickaël Horn on 26/04/2023.
//

import Foundation
import FirebaseFirestore

class UserUpdatingService {
    // MARK: - PROPERTIES & INIT
    private let userTableConstants = Constant.FirestoreTables.User.self
    private let firestoreDatabase: Firestore

    init(firestoreDatabase: Firestore = Firestore.firestore()) {
        self.firestoreDatabase = firestoreDatabase
    }
    
    // MARK: - FUNCTIONS
    func updateUser(fields: [String:Any]) async throws {
        guard let currentUserID = UserAuth.shared.currentUser?.uid else {
            throw Errors.DatabaseError.noUser
        }
        
        do {
            try await firestoreDatabase.collection(userTableConstants.tableName).document(currentUserID).updateData(fields)

        } catch {
            throw Errors.DatabaseError.cannotUploadDocuments
        }
    }
}
