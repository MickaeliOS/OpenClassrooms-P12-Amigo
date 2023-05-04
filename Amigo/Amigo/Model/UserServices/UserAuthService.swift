//
//  UserAuthService.swift
//  Amigo
//
//  Created by Mickaël Horn on 26/04/2023.
//

import Foundation
import FirebaseAuth

class UserAuthService {
    // MARK: - PROPERTIES & INIT
    private let userTableConstants = Constant.FirestoreTables.User.self
    private let firebaseAuth: Auth

    init(firebaseAuth: Auth = Auth.auth()) {
        self.firebaseAuth = firebaseAuth
    }
    
    // MARK: - FUNCTIONS
    func signIn(email: String, password: String) async throws {
        guard Utilities.isValidEmail(email) else {
            throw Errors.SignInError.badlyFormattedEmail
        }
        
        do {
            try await firebaseAuth.signIn(withEmail: email, password: password)
            
        } catch let error as NSError {
            
            switch error.code {
            case AuthErrorCode.wrongPassword.rawValue,
                AuthErrorCode.userNotFound.rawValue:
                throw Errors.SignInError.incorrectLogs
            default:
                throw Errors.SignInError.defaultError
            }
        }
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw Errors.SignOutError.cannotSignOut
        }
    }
}
