//
//  JourneyDeletionService.swift
//  Amigo
//
//  Created by Mickaël Horn on 15/05/2023.
//

import Foundation
import FirebaseFirestore

final class JourneyDeletionService {
    // MARK: - PROPERTIES & INIT
    private let journeyTableConstants = Constant.FirestoreTables.Journey.self
    private let firestoreDatabase: Firestore
    
    init(firestoreDatabase: Firestore = Firestore.firestore()) {
        self.firestoreDatabase = firestoreDatabase
    }
    
    //MARK: - FUNCTIONS
    func deleteJourney(tripID: String) async throws {
        do {
            try await firestoreDatabase.collection(journeyTableConstants.tableName).document(tripID).delete()
        } catch {
            throw Errors.DatabaseError.cannotDeleteDocuments
        }
    }
}
