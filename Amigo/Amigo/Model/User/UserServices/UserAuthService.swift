//
//  UserAuthService.swift
//  Amigo
//
//  Created by Mickaël Horn on 26/04/2023.
//

import Foundation
import FirebaseAuth

final class UserAuthService {
    // MARK: - PROPERTIES & INIT
    private let firebaseAuth: Auth

    init(firebaseAuth: Auth = Auth.auth()) {
        self.firebaseAuth = firebaseAuth
    }
    
    // MARK: - FUNCTIONS
    func signIn(email: String, password: String) async throws {
        guard String.isValidEmail(email) else {
            throw Errors.CommonError.badlyFormattedEmail
        }
        
        do {
            try await firebaseAuth.signIn(withEmail: email, password: password)
            
        } catch let error as NSError {
            
            switch error.code {
            case AuthErrorCode.wrongPassword.rawValue,
                AuthErrorCode.userNotFound.rawValue:
                throw Errors.SignInError.incorrectLogs
            default:
                throw Errors.CommonError.defaultError
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
