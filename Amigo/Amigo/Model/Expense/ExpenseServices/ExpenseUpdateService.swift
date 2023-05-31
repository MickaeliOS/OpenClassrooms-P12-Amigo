//
//  ExpenseUpdateService.swift
//  Amigo
//
//  Created by Mickaël Horn on 12/05/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ExpenseUpdateService {
    
    // MARK: - PROPERTIES & INIT
    private let firebaseWrapper: FirebaseProtocol
    private let expenseTableConstants = Constant.FirestoreTables.Expense.self
    
    init(firebaseWrapper: FirebaseProtocol = FirebaseWrapper()) {
        self.firebaseWrapper = firebaseWrapper
    }
    
    // MARK: - FUNCTIONS
    func updateExpense(expenses: Expense, for tripID: String) throws {
        do {
            try firebaseWrapper.updateExpense(expenses: expenses, for: tripID)
        } catch {
            throw Errors.DatabaseError.cannotUpdateDocuments
        }
    }
}
