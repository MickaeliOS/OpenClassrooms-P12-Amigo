//
//  Constant.swift
//  Amigo
//
//  Created by Mickaël Horn on 19/04/2023.
//

import Foundation

struct Constant {
    
    struct SegueID {
        // Unwind segues.
        static let unwindToRootVC = "unwindToRootVC"
        static let unwindToCreateTripVC = "unwindToCreateTripVC"
        
        // Classic segues.
        static let segueToDestinationPickerVC = "segueToDestinationPickerVC"
        static let segueToConfirmationTripVC = "segueToConfirmationTripVC"
    }
    
    struct TableViewCells {
        static let countryCell = "countryCell"
    }
    
    struct FirestoreTables {
        
        struct User {
            static let tableName = "User"
            
            static let firstname = "firstname"
            static let lastname = "lastname"
            static let gender = "gender"
            static let email = "email"
        }
        
        struct Trip {
            static let tableName = "Trip"
            
            static let userID = "userID"
            static let startDate = "startDate"
            static let endDate = "endDate"
            static let firstPartAddress = "firstPartAddress"
            static let secondPartAddress = "secondPartAddress"
            static let description = "description"
            static let womanOnly = "womanOnly"
        }
    }
    
    struct TableViewCell {
        static let nibName = "TripTableViewCell"
        static let tripCell = "tripCell"
    }
}
