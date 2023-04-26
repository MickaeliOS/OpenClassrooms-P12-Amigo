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
            throw UserError.CommonError.noUser
        }
        
        do {
            try await firestoreDatabase.collection(Constant.FirestoreTables.User.tableName).document(currentUser.userID).updateData(fields)

        } catch {
            throw UserError.CommonError.defaultError
        }
    }
    
    func getModifiedProperties(from changedUser: User) -> [String: Any]? {
        guard let currentUser = UserAuth.shared.user else {
            //TODO: Se relog
            return nil
        }
        
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
        
        if currentUser.profilePicture?.data != changedUser.profilePicture?.data {
            modifiedProperties[Constant.FirestoreTables.User.profilePicture] = ""
        }
        
        if currentUser.banner?.data != changedUser.banner?.data {
            modifiedProperties[Constant.FirestoreTables.User.banner] = ""
        }
        
        return modifiedProperties
    }
}
