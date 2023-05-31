//
//  TripUpdatingService.swift
//  Amigo
//
//  Created by Mickaël Horn on 09/05/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class TripUpdatingService {
    // MARK: - PROPERTIES & INIT
    private let firebaseWrapper: FirebaseProtocol
    private let tripTableConstants = Constant.FirestoreTables.Trip.self
    
    init(firebaseWrapper: FirebaseProtocol = FirebaseWrapper()) {
        self.firebaseWrapper = firebaseWrapper
    }
    
    // MARK: - FUNCTIONS
    func updateTrip(with tripID: String, fields: [String:Any]) async throws {
        do {
            try await firebaseWrapper.updateTrip(with: tripID, fields: fields)
            
        } catch let error as NSError {
            switch error.code {
            case FirestoreErrorCode.notFound.rawValue :
                throw Errors.DatabaseError.notFoundUpdate
            default:
                throw Errors.DatabaseError.cannotUpdateDocuments
            }
        }
    }
}
