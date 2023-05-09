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
    private var userAuth = UserAuth.shared
    private let tripTableConstants = Constant.FirestoreTables.Trip.self
    private let firestoreDatabase: Firestore
    
    init(firestoreDatabase: Firestore = Firestore.firestore()) {
        self.firestoreDatabase = firestoreDatabase
    }
    
    //MARK: - FUNCTIONS
    func updateJourneyList(journeyList: [Journey], for tripID: String) async throws {
        do {
            var modifiedJourneyList: [String: [Journey]] = [:]
            modifiedJourneyList[tripTableConstants.journeyList] = journeyList
            try await firestoreDatabase.collection(tripTableConstants.tableName).document(tripID).updateData(modifiedJourneyList)
            
            guard let tripIndex = userAuth.user?.trips?.firstIndex(where: { $0.tripID == tripID }) else { return }
            userAuth.user?.trips?[tripIndex].journeyList = journeyList
        } catch {
            throw Errors.DatabaseError.cannotUploadJourneyList
        }
    }
}
