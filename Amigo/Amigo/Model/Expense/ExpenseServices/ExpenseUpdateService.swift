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
    private let expenseTableConstants = Constant.FirestoreTables.Expense.self
    private let firestoreDatabase: Firestore
    private var userAuth = UserAuth.shared
    
    init(firestoreDatabase: Firestore = Firestore.firestore()) {
        self.firestoreDatabase = firestoreDatabase
    }
    
    func updateExpense(expenses: Expense, for tripID: String) throws {
        do {
            let tableRef = firestoreDatabase.collection(expenseTableConstants.tableName).document(tripID)
            try tableRef.setData(from: expenses.self)
        } catch {
            throw Errors.DatabaseError.cannotUploadDocuments
        }
    }
}
