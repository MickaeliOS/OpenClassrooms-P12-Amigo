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
    private let firebaseWrapper: FirebaseProtocol
    private let tripTableConstants = Constant.FirestoreTables.Trip.self
    
    init(firebaseWrapper: FirebaseProtocol = FirebaseWrapper()) {
        self.firebaseWrapper = firebaseWrapper
    }
    
    // MARK: - FUNCTIONS
    func createTrip(trip: Trip) throws -> String {
        do {
            return try firebaseWrapper.createTrip(trip: trip)
            
        } catch {
            throw Errors.DatabaseError.defaultError
        }
    }
}
