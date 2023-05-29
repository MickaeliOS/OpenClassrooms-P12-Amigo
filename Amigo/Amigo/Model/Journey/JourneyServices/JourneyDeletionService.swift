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
    private let firebaseWrapper: FirebaseProtocol
    private let journeyTableConstants = Constant.FirestoreTables.Journey.self
    
    init(firebaseWrapper: FirebaseProtocol = FirebaseWrapper()) {
        self.firebaseWrapper = firebaseWrapper
    }
    
    //MARK: - FUNCTIONS
    func deleteJourney(tripID: String) async throws {
        do {
            try await firebaseWrapper.deleteJourney(tripID: tripID)
        } catch {
            throw Errors.DatabaseError.cannotDeleteDocuments
        }
    }
}
