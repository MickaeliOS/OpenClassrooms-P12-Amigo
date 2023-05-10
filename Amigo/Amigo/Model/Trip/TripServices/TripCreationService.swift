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
    func createTrip(trip: Trip) throws -> String {
        do {
            let docRef = try firestoreDatabase.collection(tripTableConstants.tableName).addDocument(from: trip.self)
            return docRef.documentID
        } catch {
            throw Errors.DatabaseError.defaultError
        }
    }
}
