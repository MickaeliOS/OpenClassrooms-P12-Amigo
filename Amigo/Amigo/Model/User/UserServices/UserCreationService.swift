//
//  UserCreationService.swift
//  Amigo
//
//  Created by Mickaël Horn on 26/04/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class UserCreationService {
    
    // MARK: - PROPERTIES & INIT
    private let firebaseWrapper: FirebaseProtocol
    private let userTableConstants = Constant.FirestoreTables.User.self
    
    init(firebaseWrapper: FirebaseProtocol = FirebaseWrapper()) {
        self.firebaseWrapper = firebaseWrapper
    }
    
    // MARK: - FUNCTIONS
    func saveUserInDatabase(user: User, userID: String) async throws {
        // Before the process, I'm building the fields to be saved.
        let userData = [userTableConstants.firstname: user.firstname,
                        userTableConstants.lastname: user.lastname,
                        userTableConstants.gender: user.gender?.rawValue,
                        userTableConstants.email: user.email]
        
        do {
            try await firebaseWrapper.saveUserInDatabase(userID: userID, fields: userData as [String : Any])
            
        } catch {
            throw Errors.DatabaseError.cannotSaveUser
        }
    }
}
