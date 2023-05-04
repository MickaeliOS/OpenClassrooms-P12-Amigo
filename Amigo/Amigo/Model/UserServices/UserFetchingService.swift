//
//  UserFetchingService.swift
//  Amigo
//
//  Created by Mickaël Horn on 26/04/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserFetchingService {
    // MARK: - PROPERTIES & INIT
    private let userTableConstants = Constant.FirestoreTables.User.self
    private let firestoreDatabase: Firestore
    private let firebaseAuth: Auth

    init(firestoreDatabase: Firestore = Firestore.firestore(), firebaseAuth: Auth = Auth.auth()) {
        self.firestoreDatabase = firestoreDatabase
        self.firebaseAuth = firebaseAuth
    }
    
    // MARK: - FUNCTIONS
    func fetchUser() async throws {
        guard let currentUserID = firebaseAuth.currentUser?.uid else {
            throw Errors.CommonError.noUser
        }
        
        do {
            let result = try await firestoreDatabase.collection(userTableConstants.tableName).document(currentUserID).getDocument()
            
            guard let data = result.data() else {
                throw Errors.DatabaseError.noDocument
            }
            
            let genderString = data[userTableConstants.gender] as? String ?? ""
            let gender = User.Gender(rawValue: genderString) ?? .woman
            let user = User(
                userID: data[userTableConstants.userID] as? String ?? "",
                firstname: data[userTableConstants.firstname] as? String ?? "",
                lastname: data[userTableConstants.lastname] as? String ?? "",
                gender: gender,
                email: data[userTableConstants.email] as? String ?? "",
                description: data[userTableConstants.description] as? String,
                profilePicture: ImageInfos(image: data[userTableConstants.profilePicture] as? String),
                banner: ImageInfos(image: data[userTableConstants.banner] as? String)
            )
            
            UserAuth.shared.user = user
        } catch {
            throw Errors.DatabaseError.cannotGetDocument
        }
    }
}
