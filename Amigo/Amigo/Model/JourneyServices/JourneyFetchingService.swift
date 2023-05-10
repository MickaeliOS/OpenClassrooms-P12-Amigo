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
    
    func fetchTripJourney(tripID: String) async throws -> Journey {
        do {
            print(journeyTableConstants.tableName)
            let tableRef = firestoreDatabase.collection(journeyTableConstants.tableName).document(tripID)
            //let journey = try await tableRef.getDocument()
            let journey = try await tableRef.getDocument(as: Journey.self)
            return journey
        } catch {
            throw Errors.DatabaseError.cannotGetDocuments
        }
    }
    
    func fetchTripJourney2(tripID: String, completion: @escaping (Journey?, Errors.DatabaseError?) -> Void) {
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
    
    /*func fetchTripJourney2(tripID: String, completion: @escaping (Journey?) -> Void) {
        let tableRef = firestoreDatabase.collection("Journey").document(tripID)
        tableRef.collection(journeyTableConstants.tableName).document(tripID).getDocument { result, error in
            if let error = error {
                print(error)
                completion(nil)
            }
            
            if let result = result {
                let resultat = try? result.data(as: Journey.self)
                completion(nil)
            }
        }
    }*/
}
