//
//  Constant.swift
//  Amigo
//
//  Created by Mickaël Horn on 19/04/2023.
//

import Foundation

struct Constant {
    
    //MARK: - SEGUES
    struct SegueID {
        // Unwind segues.
        static let unwindToRootVC = "unwindToRootVC"
        static let unwindToCreateTripVC = "unwindToCreateTripVC"
        static let unwindToTripJourneyVC = "unwindToTripJourneyVC"
        
        // Trip segues.
        static let segueToCountryPickerVC = "segueToCountryPickerVC"
        static let segueToConfirmationTripVC = "segueToConfirmationTripVC"
        static let segueToTripDetailVC = "segueToTripDetailVC"
        
        // Journey segues.
        static let segueToTripJourneyVC = "segueToTripJourneyVC"
        static let segueToCreateJourneyVC = "segueToCreateJourneyVC"
        
        // To Do List segues.
        static let segueToToDoList = "segueToToDoList"
        
        // Expenses segues.
        static let segueToExpensesVC = "segueToExpensesVC"
    }
    
    //MARK: - CELLS
    struct TableViewCells {
        // Trip
        static let tripNibName = "TripTableViewCell"
        static let tripCell = "tripCell"
        
        // Country
        static let countryNibName = "CountryTableViewCell"

        static let countryCell = "countryCell"
        
        // Journey
        static let journeyNibName = "JourneyTableViewCell"
        static let journeyCell = "journeyCell"
        static let journeyLocationCell = "journeyLocationCell"
        
        // Expense
        static let expenseNibName = "ExpenseTableViewCell"
        static let expenseCell = "expenseCell"
    }
    
    struct CollectionViewCells {
        static let toDoNibName = "ToDoCollectionViewCell"

        static let toDoCell = "toDoCell"
    }
    
    //MARK: - DATABASE
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
            static let toDoList = "toDoList"
        }
        
        struct Journey {
            static let tableName = "Journey"

            static let locations = "locations"
        }
        
        struct Expense {
            static let tableName = "Expense"
            
            static let title = "title"
            static let amount = "amount"
            static let date = "date"
        }
    }
}
