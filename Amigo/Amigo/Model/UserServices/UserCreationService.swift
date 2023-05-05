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
    func createUser(email: String, password: String) async throws -> FirebaseAuth.User {
        do {
            let result = try await firebaseAuth.createUser(withEmail: email, password: password)
            return result.user
            
        } catch let error as NSError {
            switch error.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                throw Errors.CreateAccountError.emailAlreadyInUse
            default:
                throw Errors.CreateAccountError.defaultError
            }
        }
    }
    
    func saveUserInDatabase(user: User) async throws {
        // Il faudra trouver un moyen pour que l'utilisateur soit sauvegardé dans la base après sa création dans l'Auth, car sinon il va réappuyer sur le bouton pour créer son compte et ça marchera pas, ça lui dira email déjà utilisé. Du coup les throws ne servent probablement pas.
        guard let currentUserID = UserAuth.shared.currentUser?.uid else {
            throw Errors.DatabaseError.noUser
        }
        let userData = [userTableConstants.firstname: user.firstname,
                        userTableConstants.lastname: user.lastname,
                        userTableConstants.gender: user.gender.rawValue,
                        userTableConstants.email: user.email]
        
        do {
            try await firestoreDatabase.collection(userTableConstants.tableName).document(currentUserID).setData(userData)
        } catch {
            throw Errors.DatabaseError.cannotSaveUser
        }
    }
    
    func creationAccountFormControl(email: String?,
                                    password: String?,
                                    confirmPassword: String?,
                                    lastname: String?,
                                    firstname: String?,
                                    gender: String?) throws {
        
        guard emptyControl(fields: [email, password, confirmPassword, lastname, firstname, gender]) else {
            throw Errors.CreateAccountError.emptyFields
        }
        
        guard Utilities.isValidEmail(email!) else {
            throw Errors.CreateAccountError.badlyFormattedEmail
        }
        
        guard passwordEqualityCheck(password: password!, confirmPassword: confirmPassword!) else {
            throw Errors.CreateAccountError.passwordsNotEquals
        }
        
        guard Utilities.isValidPassword(password!) else {
            throw Errors.CreateAccountError.weakPassword
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
