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
    private let journeyTableConstants = Constant.FirestoreTables.Journey.self
    private let firestoreDatabase: Firestore
    private var userAuth = UserAuth.shared
    
    init(firestoreDatabase: Firestore = Firestore.firestore()) {
        self.firestoreDatabase = firestoreDatabase
    }
    
    //MARK: - FUNCTIONS
    func updateJourney(journey: Journey, for tripID: String) throws {
        do {
            let tableRef = firestoreDatabase.collection(journeyTableConstants.tableName).document(tripID)
            try tableRef.setData(from: journey.self)
        } catch {
            throw Errors.DatabaseError.cannotUploadDocuments
        }
    }
}
