//
//  Theme.swift
//  Amigo
//
//  Created by Mickaël Horn on 18/04/2023.
//

import Foundation
import UIKit

enum Theme: Int {
    // MARK: - SINGLETON
    static let shared = Theme()
    private init() {
        self = .unspecified
    }
    
    case unspecified
    case light
    case dark
    
    var interfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .unspecified:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }    
    
    func saveMode(sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "theme")
    }
    
    func changeMode(mode: UIUserInterfaceStyle) {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first(where: { $0.isKeyWindow })?
            .overrideUserInterfaceStyle = mode
    }
}

/*
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
     func createUser(email: String, password: String, completion: @escaping (Bool, CreateAccountError?) -> Void) {
         if isValidEmail(email) {
             Auth.auth().createUser(withEmail: email, password: password) { result, error in
                 guard let _ = result?.user, error == nil else {
                     if let error = error as NSError? {
                         switch error.code {
                         case AuthErrorCode.emailAlreadyInUse.rawValue:
                             completion(false, .emailAlreadyInUse)
                         default:
                             completion(false, .defaultError)
                         }
                     }
                     return
                 }
                 
                 completion(true, nil)
             }
         } else {
             completion(true, .badlyFormattedEmail)
         }
     }
     
     func saveUserInDatabase(user: User, completion: @escaping (Bool, DatabaseError?) -> Void) {
         let database = Firestore.firestore()
         let userData = ["userID": user.userID,
                         "email": user.email,
                         "lastname": user.lastname,
                         "firstname": user.firstname,
                         "gender": user.gender.rawValue]
         
         database.collection("User").document(user.userID).setData(userData) { error in
             guard error != nil else {
                 completion(false, .defaultError)
                 return
             }

             completion(true, nil)
         }
     }
     
     func signIn(email: String, password: String, completion: @escaping (Bool, SignInError?) -> Void) {
         if isValidEmail(email) {
             Auth.auth().signIn(withEmail: email, password: password) { result, error in
                 guard let _ = result?.user, error == nil else {
                     if let error = error as NSError? {
                         switch error.code {
                         case AuthErrorCode.wrongPassword.rawValue,
                             AuthErrorCode.userNotFound.rawValue:
                             completion(false, .incorrectLogs)
                             return
                         default:
                             completion(false, .defaultError)
                         }
                     }
                     return
                 }
             
                 completion(true, nil)
             }
         } else {
             completion(false, .badlyFormattedEmail)
         }
     }
     
     func fetchUser(completion: @escaping (Bool, DatabaseError?) -> Void) {
         guard let currentUserID = Auth.auth().currentUser?.uid else {
             completion(false, .noUser)
             return
         }

         Firestore.firestore().collection("User").document(currentUserID).getDocument { document, error in
             if let _ = error {
                 completion(false, .cannotGetDocument)
                 return
             }

             guard let data = document?.data() else {
                 completion(false, .noDocument)
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
             completion(true, nil)
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
         case defaultError
         
         var localizedDescription: String {
             switch self {
             case .emailAlreadyInUse:
                 return "Email already in use. Please choose a different one."
             case .badlyFormattedEmail:
                 return "Badly formatted email, please provide a correct one."
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
     func isValidEmail(_ email: String) -> Bool {
         // Firebase already warns us about badly formatted email addresses, but this involves a network call.
         // To help with Green Code, I prefer to handle the email format validation myself.
         
         let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
         let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
         return emailPred.evaluate(with: email)
     }
 }

 */
