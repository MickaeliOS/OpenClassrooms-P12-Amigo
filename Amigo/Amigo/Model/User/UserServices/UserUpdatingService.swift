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
    private let firebaseWrapper: FirebaseProtocol
    private let userTableConstants = Constant.FirestoreTables.User.self

    init(firebaseWrapper: FirebaseProtocol = FirebaseWrapper()) {
        self.firebaseWrapper = firebaseWrapper
    }
    
    // MARK: - FUNCTIONS
    func updateUser(fields: [String:Any], userID: String) async throws {
        do {
            try await firebaseWrapper.updateUser(fields: fields, userID: userID)
        } catch let error as NSError {
            switch error.code {
            case FirestoreErrorCode.notFound.rawValue:
                throw Errors.DatabaseError.notFoundUpdate
            default:
                throw Errors.DatabaseError.defaultError
            }
        }
    }
}
