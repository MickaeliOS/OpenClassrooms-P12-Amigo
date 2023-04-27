//
//  TripCreationService.swift
//  Amigo
//
//  Created by Mickaël Horn on 27/04/2023.
//

import Foundation
import FirebaseFirestore

class TripCreationService {
    // MARK: - PROPERTIES & INIT
    private let tripTableConstants = Constant.FirestoreTables.Trip.self
    private let firestoreDatabase: Firestore
    
    init(firestoreDatabase: Firestore = Firestore.firestore()) {
        self.firestoreDatabase = firestoreDatabase
    }
    
    // MARK: - FUNCTIONS
    func createTrip(trip: Trip, for user: User, completion: @escaping (Error?) -> Void) {
        var tripData: [String : Any] = [tripTableConstants.userID: trip.user.userID,
                                        tripTableConstants.startDate: trip.startDate,
                                        tripTableConstants.endDate: trip.endDate,
                                        tripTableConstants.destination: trip.destination,
                                        tripTableConstants.description: trip.description]
        
        if user.gender == .woman {
            tripData[tripTableConstants.womanOnly] = trip.womanOnly
        }
        
        firestoreDatabase.collection(tripTableConstants.tableName).addDocument(data: tripData) { error in
            if error != nil {
                completion(UserError.DatabaseError.defaultError)
                return
            }
            
            completion(nil)
        }
    }
}
