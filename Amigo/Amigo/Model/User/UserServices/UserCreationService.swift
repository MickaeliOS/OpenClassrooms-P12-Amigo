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
    private let userTableConstants = Constant.FirestoreTables.User.self
    private let firebaseAuth: Auth
    private let firestoreDatabase: Firestore

    init(firebaseAuth: Auth = Auth.auth(),
         firestoreDatabase: Firestore = Firestore.firestore()) {
        
        self.firebaseAuth = firebaseAuth
        self.firestoreDatabase = firestoreDatabase
    }
    
    // MARK: - FUNCTIONS
    func createUser(email: String, password: String) async throws {
        do {
            let _ = try await firebaseAuth.createUser(withEmail: email, password: password)
            
        } catch let error as NSError {
            switch error.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                throw Errors.CreateAccountError.emailAlreadyInUse
            default:
                throw Errors.CommonError.defaultError
            }
        }
    }
    
    func saveUserInDatabase(user: User, userID: String) async throws {
        let userData = [userTableConstants.firstname: user.firstname,
                        userTableConstants.lastname: user.lastname,
                        userTableConstants.gender: user.gender?.rawValue,
                        userTableConstants.email: user.email]

        
        do {
            try await firestoreDatabase.collection(userTableConstants.tableName).document(userID).setData(userData as [String : Any])
        } catch {
            throw Errors.DatabaseError.cannotSaveUser
        }
    }
    
    func emptyFieldsFormControl(email: String?, password: String?, confirmPassword: String?) throws {
        
        // Empty control.
        guard String.emptyControl(fields: [email, password, confirmPassword]) else {
            throw Errors.CommonError.emptyFields
        }
    }
    
    func checkingLogs(email: String, password: String, confirmPassword: String) throws {
        // Mail and Password check.
        guard String.isValidEmail(email) else {
            throw Errors.CommonError.badlyFormattedEmail
        }
        
        guard String.isValidPassword(password) else {
            throw Errors.CreateAccountError.weakPassword
        }
        
        guard passwordEqualityCheck(password: password, confirmPassword: confirmPassword) else {
            throw Errors.CreateAccountError.passwordsNotEquals
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func passwordEqualityCheck(password: String, confirmPassword: String) -> Bool {
        return password == confirmPassword
    }
}
