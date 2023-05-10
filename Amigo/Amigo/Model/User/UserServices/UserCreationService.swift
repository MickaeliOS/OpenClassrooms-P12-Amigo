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
                throw Errors.CommonError.defaultError
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
    
    func emptyFieldsFormControl(email: String?,
                                    password: String?,
                                    confirmPassword: String?,
                                    lastname: String?,
                                    firstname: String?,
                                    gender: String?) throws {
        
        // Empty control.
        guard String.emptyControl(fields: [email, password, confirmPassword, lastname, firstname, gender]) else {
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
