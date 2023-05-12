//
//  ExpenseFetchingService.swift
//  Amigo
//
//  Created by Mickaël Horn on 12/05/2023.
//

import Foundation
import FirebaseFirestore

final class ExpenseFetchingService {
    // MARK: - PROPERTIES & INIT
    private let expenseTableConstants = Constant.FirestoreTables.Expense.self
    private let firestoreDatabase: Firestore
    private var userAuth = UserAuth.shared
    
    init(firestoreDatabase: Firestore = Firestore.firestore()) {
        self.firestoreDatabase = firestoreDatabase
    }
    
    // MARK: - FUNCTIONS
    func fetchTripExpenses(tripID: String, completion: @escaping (Expense?, Errors.DatabaseError?) -> Void) {
        let tableRef = firestoreDatabase.collection(expenseTableConstants.tableName).document(tripID)
        
        tableRef.getDocument { document, error in
            if error != nil {
                completion(nil, .cannotGetDocuments)
                return
            }
            
            if let document = document, document.exists {
                let convertedExpense = try? document.data(as: Expense.self)
                completion(convertedExpense, nil)
                return
            }
            
            completion(nil, nil)
        }
    }
}
