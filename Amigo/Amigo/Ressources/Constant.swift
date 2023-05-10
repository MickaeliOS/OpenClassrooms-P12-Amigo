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
        static let unwindToTripJourneyVC = "unwindToTripJourneyVC"
        
        // Adding trip segues.
        static let segueToCountryPickerVC = "segueToCountryPickerVC"
        static let segueToConfirmationTripVC = "segueToConfirmationTripVC"
        
        // Trip Management segues.
        static let segueToTripDetailVC = "segueToTripDetailVC"
        static let segueToTripJourneyVC = "segueToTripJourneyVC"
        static let segueToCreateJourneyVC = "segueToCreateJourneyVC"
    }
    
    struct TableViewCells {
        // Trip
        static let tripNibName = "TripTableViewCell"
        static let tripCell = "tripCell"
        
        // Country
        static let countryCell = "countryCell"
        
        // Journey
        static let journeyNibName = "JourneyTableViewCell"
        static let journeyCell = "journeyCell"
        static let journeyDestinationCell = "journeyDestinationCell"
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
            static let country = "country"
            static let countryCode = "countryCode"
            static let journey = "journey"
        }
        
        struct Journey {
            static let tableName = "Journey"

            static let locations = "locations"
        }
    }
}
