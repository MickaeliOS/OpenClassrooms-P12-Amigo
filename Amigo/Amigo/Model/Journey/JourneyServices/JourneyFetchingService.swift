//
//  JourneyFetchingService.swift
//  Amigo
//
//  Created by Mickaël Horn on 09/05/2023.
//

import Foundation
import FirebaseFirestore

final class JourneyFetchingService {
    // MARK: - PROPERTIES & INIT
    private let journeyTableConstants = Constant.FirestoreTables.Journey.self
    private let firestoreDatabase: Firestore
    private var userAuth = UserAuth.shared
    
    init(firestoreDatabase: Firestore = Firestore.firestore()) {
        self.firestoreDatabase = firestoreDatabase
    }
    
    // MARK: - FUNCTIONS
    func fetchTripJourney(tripID: String, completion: @escaping (Journey?, Errors.DatabaseError?) -> Void) {
        let tableRef = firestoreDatabase.collection(journeyTableConstants.tableName).document(tripID)
        
        tableRef.getDocument { document, error in
            if error != nil {
                completion(nil, .cannotGetDocuments)
                return
            }
            
            if let document = document, document.exists {
                let convertedJourney = try? document.data(as: Journey.self)
                completion(convertedJourney, nil)
                return
            }
            
            completion(nil, nil)
        }
    }
}
