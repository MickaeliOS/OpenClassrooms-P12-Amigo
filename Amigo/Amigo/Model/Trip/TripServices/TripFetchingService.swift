//
//  TripFetchingService.swift
//  Amigo
//
//  Created by Mickaël Horn on 28/04/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class TripFetchingService {
    // MARK: - PROPERTIES & INIT
    private let firebaseWrapper: FirebaseProtocol
    private let tripTableConstants = Constant.FirestoreTables.Trip.self
    
    init(firebaseWrapper: FirebaseProtocol = FirebaseWrapper()) {
        self.firebaseWrapper = firebaseWrapper
    }
    
    //MARK: - FUNCTIONS
    func fetchTrips(userID: String) async throws -> [Trip] {
        do {
            return try await firebaseWrapper.fetchTrips(userID: userID)
            
        } catch {
            throw Errors.DatabaseError.cannotGetDocuments
        }
    }
}
