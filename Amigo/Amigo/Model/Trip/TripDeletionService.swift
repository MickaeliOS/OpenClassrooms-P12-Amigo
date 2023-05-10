//
//  TripDeletionService.swift
//  Amigo
//
//  Created by Mickaël Horn on 03/05/2023.
//

import Foundation
import FirebaseFirestore

final class TripDeletionService {
    // MARK: - PROPERTIES & INIT
    private let tripTableConstants = Constant.FirestoreTables.Trip.self
    private let firestoreDatabase: Firestore
    
    init(firestoreDatabase: Firestore = Firestore.firestore()) {
        self.firestoreDatabase = firestoreDatabase
    }
    
    //MARK: - FUNCTIONS
    func deleteTrip(tripID: String) async throws {
        do {
            try await firestoreDatabase.collection(tripTableConstants.tableName).document(tripID).delete()
        } catch {
            throw Errors.DatabaseError.cannotDeleteTrip
        }
    }
}
