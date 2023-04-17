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
    
    // MARK: - USER MANAGEMENT
    func createUser(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard result?.user != nil else {
                completion(false, nil)
                return
            }
            completion(true, nil)
        }
    }
    
    func saveUserInDatabase(user: User, completion: @escaping (Bool, Error?) -> Void) {
        let database = Firestore.firestore()
        let userData = ["userID": user.userID,
                        "email": user.email,
                        "lastname": user.lastname,
                        "firstname": user.firstname,
                        "gender": user.gender.rawValue]
        
        database.collection("User").document(user.userID).setData(userData) { error in
            guard error == nil else {
                //TODO: Erreur lors de la sauvegarde
                print("MKA - ERROR DB")
                completion(false, error)
                return
            }
            print("MKA - OK DB")

            completion(true, nil)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (SignInError?) -> Void) {
        if isValidEmail(email) {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
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
                
                guard let _ = result else {
                    completion(.defaultError)
                    return
                }
            
                completion(nil)
            }
        } else {
            completion(SignInError.badlyFormattedEmail)
        }
    }
    
    func fetchUser(completion: @escaping (databaseError?) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(.noUser)
            return
        }

        Firestore.firestore().collection("User").document(currentUserID).getDocument { document, error in
            if let _ = error {
                //TODO: Handle Error
                completion(.cannotGetDocument)
                return
            }

            guard let data = document?.data() else {
                //TODO: Handle no data
                completion(.emptyDocument)
                return
            }
            
            let genderString = data["gender"] as? String ?? ""
            let gender = User.Gender(rawValue: genderString) ?? .woman

            let user = User(
                userID: data["userID"] as? String ?? "",
                firstname: data["firstname"] as? String ?? "",
                lastname: data["lastname"] as? String ?? "",
                gender: gender,
                email: data["email"] as? String ?? ""
            )
            
            UserService.shared.user = user
            completion(nil)
        }
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw UserService.signOutError.cannotSignOut
        }
    }
}

// MARK: - ERROR HANDLING
extension UserService {
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
    
    enum databaseError: Error {
        case emptyDocument
        case cannotGetDocument
        case noUser
        
        var localizedDescription: String {
            switch self {
            case .emptyDocument:
                return "No document found."
            case .cannotGetDocument:
                return "We couldn't retrieve your document, try to log in again."
            case .noUser:
                return "You are not logged in, please log in again."
            }
        }
    }
    
    enum signOutError: Error {
        case cannotSignOut
        
        var localizedDescription: String {
            switch self {
            case .cannotSignOut:
                return "Unable to log you out. Please restart the application and attempt the logout process again."
            }
        }
    }
}

// MARK: - USER CONTROL
extension UserService {
    func isValidEmail(_ email: String) -> Bool {
        // Firebase already warns us about badly formatted email addresses, but this involves a network call.
        // To help with Green Code, I prefer to handle the email format validation myself.
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
