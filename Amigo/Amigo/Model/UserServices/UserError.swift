//
//  UserError.swift
//  Amigo
//
//  Created by Mickaël Horn on 26/04/2023.
//

import Foundation

struct UserError {
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
    
    enum SignOutError: Error {
        case cannotSignOut
        
        var localizedDescription: String {
            switch self {
            case .cannotSignOut:
                return "Unable to log you out. Please restart the application and attempt the logout process again."
            }
        }
    }
    
    enum DatabaseError: Error {
        case noDocument
        case cannotGetDocument
        case defaultError
        
        var localizedDescription: String {
            switch self {
            case .noDocument:
                return "No document found."
            case .cannotGetDocument:
                return "We couldn't retrieve your document, try to log in again."
            case .defaultError:
                return "An database error occurred, please try again."
            }
        }
    }
    
    enum CommonError: Error {
        case noUser
        case defaultError
        
        var localizedDescription: String {
            switch self {
            case .noUser:
                return "You are not logged in, please log in again."
            case .defaultError:
                return "Something went wrong, please try again."
            }
        }
    }
}
