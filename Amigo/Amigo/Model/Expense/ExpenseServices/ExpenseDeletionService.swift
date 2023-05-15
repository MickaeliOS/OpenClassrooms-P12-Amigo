//
//  ExpenseDeletionService.swift
//  Amigo
//
//  Created by Mickaël Horn on 15/05/2023.
//

import Foundation
import FirebaseFirestore

final class ExpenseDeletionService {
    // MARK: - PROPERTIES & INIT
    private let expenseTableConstants = Constant.FirestoreTables.Expense.self
    private let firestoreDatabase: Firestore
    
    init(firestoreDatabase: Firestore = Firestore.firestore()) {
        self.firestoreDatabase = firestoreDatabase
    }
    
    //MARK: - FUNCTIONS
    func deleteExpense(tripID: String) async throws {
        do {
            try await firestoreDatabase.collection(expenseTableConstants.tableName).document(tripID).delete()
        } catch {
            throw Errors.DatabaseError.cannotDeleteDocuments
        }
    }
}
