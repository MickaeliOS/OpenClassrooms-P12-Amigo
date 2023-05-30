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
    private let firebaseWrapper: FirebaseProtocol
    private let userTableConstants = Constant.FirestoreTables.User.self

    init(firebaseWrapper: FirebaseProtocol = FirebaseWrapper()) {
        self.firebaseWrapper = firebaseWrapper
    }
    
    // MARK: - FUNCTIONS
    func fetchUser(userID: String) async throws -> User? {
        do {            
            return try await firebaseWrapper.fetchUser(userID: userID)
            
        } catch {
            throw Errors.DatabaseError.cannotGetDocuments
        }
    }
}
