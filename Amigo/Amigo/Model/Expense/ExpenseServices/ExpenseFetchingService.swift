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
    private let firebaseWrapper: FirebaseProtocol
    private let expenseTableConstants = Constant.FirestoreTables.Expense.self
    
    init(firebaseWrapper: FirebaseProtocol = FirebaseWrapper()) {
        self.firebaseWrapper = firebaseWrapper
    }
    
    // MARK: - FUNCTIONS
    func fetchTripExpenses(tripID: String, completion: @escaping (Expense?, Errors.DatabaseError?) -> Void) {
        firebaseWrapper.fetchTripExpenses(tripID: tripID) { expense, error in
            guard error == nil else {
                completion(nil, .cannotGetDocuments)
                return
            }
            
            completion(expense, nil)
        }
    }
}
