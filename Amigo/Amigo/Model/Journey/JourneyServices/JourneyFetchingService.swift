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
    private let firebaseWrapper: FirebaseProtocol
    private let journeyTableConstants = Constant.FirestoreTables.Journey.self
    
    init(firebaseWrapper: FirebaseProtocol = FirebaseWrapper()) {
        self.firebaseWrapper = firebaseWrapper
    }
    
    // MARK: - FUNCTIONS
    func fetchTripJourney(tripID: String, completion: @escaping (Journey?, Errors.DatabaseError?) -> Void) {
        firebaseWrapper.fetchTripJourney(tripID: tripID) { journey, error in
            guard error == nil else {
                completion(nil, .cannotGetDocuments)
                return
            }
            
            completion(journey, nil)
        }
    }
}
