//
//  UserError.swift
//  Amigo
//
//  Created by Mickaël Horn on 26/04/2023.
//

import Foundation

struct Errors {
    enum CreateAccountError: Error {
        case emailAlreadyInUse
        case weakPassword
        case passwordsNotEquals
        case defaultError
        
        var localizedDescription: String {
            switch self {
            case .emailAlreadyInUse:
                return "Email already in use. Please choose a different one."
            case .weakPassword:
                return "Your password is too weak. It must be : \n - At least 7 characters long \n - At least one uppercase letter \n - At least one number"
            case .passwordsNotEquals:
                return "Passwords must be equals."
            case .defaultError:
                return "An error occurred, please try again."
            }
        }
    }
    
    enum SignInError: Error {
        case incorrectLogs
        
        var localizedDescription: String {
            switch self {
            case .incorrectLogs:
                return "Incorrect Email or Password."
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
        case noUser
        case cannotGetDocuments
        case cannotUploadDocuments
        case cannotSaveUser
        case cannotDeleteDocuments
        case noTripID
        case nothingToAdd
        case defaultError
        
        var localizedDescription: String {
            switch self {
            case .noUser:
                return "Unfortunately, we were unable to retrieve your information due to a disconnection. Please log in again."
            case .cannotGetDocuments:
                return "We couldn't retrieve your document(s), please try to log in again."
            case .cannotUploadDocuments:
                return "We couldn't upload your document(s), please try again."
            case .cannotSaveUser:
                return "We couldn't save your informations, please try again."
            case .cannotDeleteDocuments:
                return "We couldn't delete your document(s), please try again."
            case .noTripID:
                return "An Unexpected error occured, try to log in again to delete your Trip."
            case .nothingToAdd:
                return "There is nothing to save, please add some content first."
            case .defaultError:
                return "A database error occurred, please try again."
            }
        }
    }
    
    enum CommonError: Error {
        case noUser
        case emptyFields
        case badlyFormattedEmail
        case defaultError
        
        var localizedDescription: String {
            switch self {
            case .noUser:
                return "You are not logged in, please log in again."
            case .emptyFields:
                return "All fields must be filled."
            case .badlyFormattedEmail:
                return "Badly formatted email, please provide a correct one."
            case .defaultError:
                return "Something went wrong, please try again."
            }
        }
    }
}
