//
//  UserService.swift
//  Amigo
//
//  Created by Mickaël Horn on 11/04/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserService {
    // MARK: - SINGLETON
    static let shared = UserService()
    private init() {}
    
    // MARK: - USER
    var user: User?
    var currentlyLoggedIn: Bool {
        Auth.auth().currentUser != nil
    }
    let userTableConstants = Constant.FirestoreTables.User.self
    
    // MARK: - USER MANAGEMENT
    func createUser(email: String?, password: String?, completion: @escaping (FirebaseAuth.User?, CreateAccountError?) -> Void) {
        Auth.auth().createUser(withEmail: email!, password: password!) { result, error in
            guard let user = result?.user, error == nil else {
                if let error = error as NSError? {
                    switch error.code {
                    case AuthErrorCode.emailAlreadyInUse.rawValue:
                        completion(nil, .emailAlreadyInUse)
                    default:
                        completion(nil, .defaultError)
                    }
                }
                return
            }
            
            completion(user, nil)
        }
    }
    
    func saveUserInDatabase(user: User, completion: @escaping (DatabaseError?) -> Void) {
        let database = Firestore.firestore()
        let userData = [userTableConstants.userID: user.userID,
                        userTableConstants.firstname: user.firstname,
                        userTableConstants.lastname: user.lastname,
                        userTableConstants.gender: user.gender.rawValue,
                        userTableConstants.email: user.email]
        
        database.collection(userTableConstants.tableName).document(user.userID).setData(userData) { error in
            guard error == nil else {
                completion(.defaultError)
                return
            }
            
            completion(nil)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (SignInError?) -> Void) {
        if isValidEmail(email) {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                guard let _ = result?.user, error == nil else {
                    if let error = error as NSError? {
                        switch error.code {
                        case AuthErrorCode.wrongPassword.rawValue,
                            AuthErrorCode.userNotFound.rawValue:
                            completion(.incorrectLogs)
                            return
                        default:
                            completion(.defaultError)
                        }
                    }
                    return
                }
                
                completion(nil)
            }
        } else {
            completion(.badlyFormattedEmail)
        }
    }
    
    func fetchUser(completion: @escaping (DatabaseError?) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(.noUser)
            return
        }
        
        Firestore.firestore().collection(userTableConstants.tableName).document(currentUserID).getDocument { [weak self] document, error in
            guard let self = self else { return } // Pas sûr de ce cas la, à revoir
            
            if let _ = error {
                completion(.cannotGetDocument)
                return
            }
            
            guard let data = document?.data() else {
                completion(.noDocument)
                return
            }

            let genderString = data[self.userTableConstants.gender] as? String ?? ""
            let gender = User.Gender(rawValue: genderString) ?? .woman
            
            let user = User(
                userID: data[self.userTableConstants.userID] as? String ?? "",
                firstname: data[self.userTableConstants.firstname] as? String ?? "",
                lastname: data[self.userTableConstants.lastname] as? String ?? "",
                gender: gender,
                email: data[self.userTableConstants.email] as? String ?? ""
            )
            
            UserService.shared.user = user
            completion(nil)
        }
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw SignOutError.cannotSignOut
        }
    }
}

// MARK: - ERROR HANDLING
extension UserService {
    enum CreateAccountError: Error {
        case emailAlreadyInUse
        case badlyFormattedEmail
        case weakPassword
        case emptyFields
        case passwordsNotEquals
        case defaultError
        
        var localizedDescription: String {
            switch self {
            case .emailAlreadyInUse:
                return "Email already in use. Please choose a different one."
            case .badlyFormattedEmail:
                return "Badly formatted email, please provide a correct one."
            case .weakPassword:
                return "Your password is too weak. It must be : \n - At least 7 characters long \n - At least one uppercase letter \n - At least one number"
            case .emptyFields:
                return "All fields must be filled."
            case .passwordsNotEquals:
                return "Passwords must be equals."
            case .defaultError:
                return "An error occurred, please try again."
            }
        }
    }
    
    enum SignInError: Error {
        case incorrectLogs
        case badlyFormattedEmail
        case defaultError
        
        var localizedDescription: String {
            switch self {
            case .incorrectLogs:
                return "Incorrect Email or Password."
            case .badlyFormattedEmail:
                return "Badly formatted email, please provide a correct one."
            case .defaultError:
                return "An error occurred, please try again."
            }
        }
    }
    
    enum DatabaseError: Error {
        case noDocument
        case cannotGetDocument
        case noUser
        case defaultError
        
        var localizedDescription: String {
            switch self {
            case .noDocument:
                return "No document found."
            case .cannotGetDocument:
                return "We couldn't retrieve your document, try to log in again."
            case .noUser:
                return "You are not logged in, please log in again."
            case .defaultError:
                return "An error occurred, please try again."
            }
        }
    }
    
    enum SignOutError: Error {
        case cannotSignOut
        
        var localizedDescription: String {
            switch self {
            case .cannotSignOut:
                return "Unable to log you out. Please restart the application and attempt the logout process again."
            }
        }
    }
    
    /*enum CommonError: Error {
     case badlyFormattedEmail
     case defaultError
     
     var message: String {
     switch self {
     case .badlyFormattedEmail:
     return "Badly formatted email, please provide a correct one."
     case .defaultError:
     return "An error occurred, please try again."
     }
     }
     }*/
}

// MARK: - USER CONTROL
extension UserService {
    func creationAccountFormControl(email: String?,
                                    password: String?,
                                    confirmPassword: String?,
                                    lastname: String?,
                                    firstname: String?,
                                    gender: String?,
                                    completion: (CreateAccountError?) -> Void) {
        
        guard emptyControl(fields: [email, password, confirmPassword, lastname, firstname, gender]) else {
            completion(.emptyFields)
            return
        }
        
        guard isValidEmail(email!) else {
            completion(.badlyFormattedEmail)
            return
        }
        
        guard passwordEqualityCheck(password: password!, confirmPassword: confirmPassword!) else {
            completion(.passwordsNotEquals)
            return
        }
        
        guard isValidPassword(password!) else {
            completion(.weakPassword)
            return
        }
        
        completion(nil)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        // Firebase already warns us about badly formatted email addresses, but this involves a network call.
        // To help with Green Code, I prefer to handle the email format validation myself.
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let regex = #"(?=^.{7,}$)(?=^.*[A-Z].*$)(?=^.*\d.*$).*"#
        
        return password.range(
            of: regex,
            options: .regularExpression
        ) != nil
    }
    
    func emptyControl(fields: [String?]) -> Bool {
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
