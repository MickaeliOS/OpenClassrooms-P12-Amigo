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
    private let firebaseWrapper: FirebaseProtocol
    private let tripTableConstants = Constant.FirestoreTables.Trip.self
    
    init(firebaseWrapper: FirebaseProtocol = FirebaseWrapper()) {
        self.firebaseWrapper = firebaseWrapper
    }
    
    //MARK: - FUNCTIONS
    func deleteTrip(tripID: String) async throws {
        do {
            try await firebaseWrapper.deleteTrip(tripID: tripID)
        } catch {
            throw Errors.DatabaseError.cannotDeleteDocuments
        }
    }
}
