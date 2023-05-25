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
    private let firebaseWrapper: FirebaseProtocol

    init(firebaseWrapper: FirebaseProtocol = FirebaseWrapper()) {
        self.firebaseWrapper = firebaseWrapper
    }
    
    // MARK: - FUNCTIONS
    func signIn(email: String, password: String) async throws {
        guard UserManagement.isValidEmail(email) else {
            throw Errors.CommonError.badlyFormattedEmail
        }
        
        do {
            try await firebaseWrapper.signIn(email: email, password: password)
            
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
            try firebaseWrapper.signOut()
        } catch {
            throw Errors.SignOutError.cannotSignOut
        }
    }
    
    func createUser(email: String, password: String, confirmPassword: String) async throws {
        do {
            // Prior to user creation, field testing is required.
            try checkingLogs(email: email, password: password, confirmPassword: confirmPassword)
            
            try await firebaseWrapper.createUser(withEmail: email, password: password)
            
        } catch let error as Errors.CommonError {
            throw error
        } catch let error as Errors.CreateAccountError {
            throw error
        } catch let error as NSError {
            switch error.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                throw Errors.CreateAccountError.emailAlreadyInUse
            default:
                throw Errors.CommonError.defaultError
            }
        }
    }
    
    private func checkingLogs(email: String, password: String, confirmPassword: String) throws {
        guard UserManagement.isValidEmail(email) else {
            throw Errors.CommonError.badlyFormattedEmail
        }
        
        guard UserManagement.isValidPassword(password) else {
            throw Errors.CreateAccountError.weakPassword
        }
        
        guard UserManagement.passwordEqualityCheck(password: password, confirmPassword: confirmPassword) else {
            throw Errors.CreateAccountError.passwordsNotEquals
        }
    }
}
