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
    private let firebaseWrapper: FirebaseProtocol
    private let expenseTableConstants = Constant.FirestoreTables.Expense.self
    
    init(firebaseWrapper: FirebaseProtocol = FirebaseWrapper()) {
        self.firebaseWrapper = firebaseWrapper
    }
    
    //MARK: - FUNCTIONS
    func deleteExpense(tripID: String) async throws {
        do {
            try await firebaseWrapper.deleteExpense(tripID: tripID)
        } catch {
            throw Errors.DatabaseError.cannotDeleteDocuments
        }
    }
}
