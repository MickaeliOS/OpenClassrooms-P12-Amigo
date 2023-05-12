//
//  Expense.swift
//  Amigo
//
//  Created by Mickaël Horn on 11/05/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct Expense: Codable {
    @DocumentID var tripID: String?
    
    // While it is expected for an Expense list to contain at least one ExpenseItem,
    // in order to prevent decoding errors from Firestore, we have marked the expenses property as optional.
    var expenseItems: [ExpenseItem]?
}

struct ExpenseItem: Codable {
    var title: String
    var amount: Double
    var date: Date
}
