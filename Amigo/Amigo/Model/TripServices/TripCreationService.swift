//
//  TripCreationService.swift
//  Amigo
//
//  Created by Mickaël Horn on 27/04/2023.
//

import Foundation
import FirebaseFirestore

final class TripCreationService {
    // MARK: - PROPERTIES & INIT
    private let tripTableConstants = Constant.FirestoreTables.Trip.self
    private let firestoreDatabase: Firestore
    
    init(firestoreDatabase: Firestore = Firestore.firestore()) {
        self.firestoreDatabase = firestoreDatabase
    }
    
    // MARK: - FUNCTIONS
    func createTrip(trip: Trip, completion: @escaping (Error?) -> Void) {
        do {
            let _ = try firestoreDatabase.collection(tripTableConstants.tableName).addDocument(from: trip.self) { error in
                if error != nil {
                    completion(Errors.DatabaseError.defaultError)
                    return
                }

                completion(nil)
            }
        } catch {
            completion(Errors.DatabaseError.defaultError)
        }
    }
}
