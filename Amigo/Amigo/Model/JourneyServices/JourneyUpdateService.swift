//
//  JourneyUpdateService.swift
//  Amigo
//
//  Created by Mickaël Horn on 09/05/2023.
//

import Foundation
import FirebaseFirestore

final class JourneyUpdateService {
    // MARK: - PROPERTIES & INIT
    private let locationTableConstants = Constant.FirestoreTables.Location.self
    private let firestoreDatabase: Firestore
    private var userAuth = UserAuth.shared
    
    init(firestoreDatabase: Firestore = Firestore.firestore()) {
        self.firestoreDatabase = firestoreDatabase
    }
    
    //MARK: - FUNCTIONS
    /*func updateJourney(journey: [Location], for tripID: String) async throws {
        do {
            try await firestoreDatabase.collection(locationTableConstants.tableName).document(tripID).updateData(modifiedJourney)
            
            guard let tripIndex = userAuth.user?.trips?.firstIndex(where: { $0.tripID == tripID }) else { return }
            userAuth.user?.trips?[tripIndex].journey = journey
        } catch {
            throw Errors.DatabaseError.cannotUploadJourneyList
        }
    }*/
}
