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
            let journeyTableRef = firestoreDatabase.collection(journeyTableConstants.tableName).document(tripID)
            let journey = try await journeyTableRef.getDocument(as: Journey.self)
            return journey
        } catch {
            throw Errors.DatabaseError.cannotGetDocuments
        }
    }
}
