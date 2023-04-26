//
//  UserCreationService.swift
//  Amigo
//
//  Created by Mickaël Horn on 26/04/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserCreationService {
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
    func createUser(email: String, password: String) async throws -> FirebaseAuth.User {
        do {
            let result = try await firebaseAuth.createUser(withEmail: email, password: password)
            return result.user
            
        } catch let error as NSError {
            switch error.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                throw UserError.CreateAccountError.emailAlreadyInUse
            default:
                throw UserError.CreateAccountError.defaultError
            }
        }
    }
    
    func saveUserInDatabase(user: User) async throws {
        let userData = [userTableConstants.userID: user.userID,
                        userTableConstants.firstname: user.firstname,
                        userTableConstants.lastname: user.lastname,
                        userTableConstants.gender: user.gender.rawValue,
                        userTableConstants.email: user.email]
        
        do {
            try await firestoreDatabase.collection(userTableConstants.tableName).document(user.userID).setData(userData)
        } catch {
            throw UserError.DatabaseError.defaultError
        }
    }
    
    func creationAccountFormControl(email: String?,
                                    password: String?,
                                    confirmPassword: String?,
                                    lastname: String?,
                                    firstname: String?,
                                    gender: String?) throws {
        
        guard emptyControl(fields: [email, password, confirmPassword, lastname, firstname, gender]) else {
            throw UserError.CreateAccountError.emptyFields
        }
        
        guard Utilities.isValidEmail(email!) else {
            throw UserError.CreateAccountError.badlyFormattedEmail
        }
        
        guard passwordEqualityCheck(password: password!, confirmPassword: confirmPassword!) else {
            throw UserError.CreateAccountError.passwordsNotEquals
        }
        
        guard Utilities.isValidPassword(password!) else {
            throw UserError.CreateAccountError.weakPassword
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func emptyControl(fields: [String?]) -> Bool {
        for field in fields {
            guard let field = field, !field.isEmpty else {
                return false
            }
        }
        return true
    }
    
    private func passwordEqualityCheck(password: String, confirmPassword: String) -> Bool {
        return password == confirmPassword
    }
}
