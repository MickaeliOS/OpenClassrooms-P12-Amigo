//
//  TripFetchingService.swift
//  Amigo
//
//  Created by Mickaël Horn on 28/04/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class TripFetchingService {
    // MARK: - PROPERTIES & INIT
    private let tripTableConstants = Constant.FirestoreTables.Trip.self
    private let firebaseAuth: Auth
    private let firestoreDatabase: Firestore
    
    init(firebaseAuth: Auth = Auth.auth(), firestoreDatabase: Firestore = Firestore.firestore()) {
        self.firebaseAuth = firebaseAuth
        self.firestoreDatabase = firestoreDatabase
    }
    
    //MARK: - FUNCTIONS
    func fetchUserTrips() async throws -> [Trip] {
        //TODO: Gérer proprement les erreurs
        guard let currentUserID = UserAuth.shared.currentUser?.uid else {
            throw Errors.DatabaseError.noUser
        }
        
        var trips: [Trip] = []
        
        do {
            // We need the user's trips, each trip we fetch must have the same userID
            let tripTableRef = firestoreDatabase.collection(tripTableConstants.tableName)
            let query = tripTableRef.whereField(tripTableConstants.userID, isEqualTo: currentUserID)
            
            let result = try await query.getDocuments()
            
            // Transforming the [QueryDocumentSnapshot] with Codable
            try result.documents.forEach { document in
                let trip = try document.data(as: Trip.self)
                trips.append(trip)
            }
            
            return trips
            
        } catch {
            throw Errors.DatabaseError.cannotGetDocuments
        }
    }
}
