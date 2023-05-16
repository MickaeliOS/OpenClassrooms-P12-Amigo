//
//  TripUpdateService.swift
//  Amigo
//
//  Created by Mickaël Horn on 09/05/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class TripUpdateService {
    // MARK: - PROPERTIES & INIT
    private let tripTableConstants = Constant.FirestoreTables.Trip.self
    private let firestoreDatabase: Firestore
    
    init(firestoreDatabase: Firestore = Firestore.firestore()) {
        self.firestoreDatabase = firestoreDatabase
    }
    
    // MARK: - FUNCTIONS
    func updateTrip(with tripID: String, fields: [String:Any]) async throws {
        do {
            try await firestoreDatabase.collection(tripTableConstants.tableName).document(tripID).updateData(fields)
        } catch {
            throw Errors.DatabaseError.cannotUploadDocuments
        }
    }
}
