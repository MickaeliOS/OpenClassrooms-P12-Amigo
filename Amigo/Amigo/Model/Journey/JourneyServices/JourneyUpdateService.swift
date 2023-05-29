//
//  JourneyUpdateService.swift
//  Amigo
//
//  Created by Mickaël Horn on 09/05/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class JourneyUpdateService {
    
    // MARK: - PROPERTIES & INIT
    private let firebaseWrapper: FirebaseProtocol
    private let journeyTableConstants = Constant.FirestoreTables.Journey.self
    
    init(firebaseWrapper: FirebaseProtocol = FirebaseWrapper()) {
        self.firebaseWrapper = firebaseWrapper
    }
    
    //MARK: - FUNCTIONS
    func updateJourney(journey: Journey, for tripID: String) throws {
        do {
            try firebaseWrapper.updateJourney(journey: journey, for: tripID)
        } catch {
            throw Errors.DatabaseError.cannotUpdateDocuments
        }
    }
}
