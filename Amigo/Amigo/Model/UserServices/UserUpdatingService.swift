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
        guard let currentUser = UserAuth.shared.user else {
            throw Errors.CommonError.noUser
        }
        
        do {
            try await firestoreDatabase.collection(Constant.FirestoreTables.User.tableName).document(currentUser.userID).updateData(fields)

        } catch {
            throw Errors.CommonError.defaultError
        }
    }
    
    func changedProperties(from currentUser: User, to changedUser: User) -> [String: Any] {
        // We don't compare the pictures because it's impossible, you'll have to use a
        // Bool to control if pictures changed inside wherever you are.
        var modifiedProperties: [String: Any] = [:]
        
        if currentUser.firstname != changedUser.firstname {
            modifiedProperties[Constant.FirestoreTables.User.firstname] = changedUser.firstname
        }
        
        if currentUser.lastname != changedUser.lastname {
            modifiedProperties[Constant.FirestoreTables.User.lastname] = changedUser.lastname
        }
        
        if currentUser.gender != changedUser.gender {
            modifiedProperties[Constant.FirestoreTables.User.gender] = changedUser.gender.rawValue
        }
        
        if currentUser.description != changedUser.description {
            modifiedProperties[Constant.FirestoreTables.User.description] = changedUser.description
        }
        
        return modifiedProperties
    }
}
