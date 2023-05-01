//
//  TripFetchingService.swift
//  Amigo
//
//  Created by Mickaël Horn on 28/04/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class TripFetchingService {
    // MARK: - PROPERTIES & INIT
    private let tripTableConstants = Constant.FirestoreTables.Trip.self
    private let firebaseAuth: Auth
    private let firestoreDatabase: Firestore
    
    init(firebaseAuth: Auth = Auth.auth(), firestoreDatabase: Firestore = Firestore.firestore()) {
        self.firebaseAuth = firebaseAuth
        self.firestoreDatabase = firestoreDatabase
    }
    
     func fetchUserTrips() async throws -> [Trip] {
        //TODO: Gérer proprement les erreurs
        guard var currentUser = UserAuth.shared.user else {
            throw UserError.CommonError.noUser
        }
        
        var trips: [Trip] = []
        
        do {
            let result = try await firestoreDatabase.collection(tripTableConstants.tableName).whereField(tripTableConstants.userID, isEqualTo: currentUser.userID).getDocuments()
                        
            try result.documents.forEach { document in
                let jsonData = try JSONSerialization.data(withJSONObject: document.data(), options: [])
                let decodedTrip = try JSONDecoder().decode(Trip.self, from: jsonData)
                trips.append(decodedTrip)
            }
            
            return trips

        } catch {
            throw UserError.DatabaseError.defaultError
        }
    }
    
    /*func fetchUserTrips() async throws {
        //TODO: Gérer proprement les erreurs, pour l'instant j'ai mis defaulterror en bas mais regarde si on peut pas être plus précis
        guard var currentUser = UserAuth.shared.user else {
            throw UserError.CommonError.noUser
        }
        
        var trips: [Trip] = []
        
        do {
            let result = try await firestoreDatabase.collection(tripTableConstants.tableName).whereField(tripTableConstants.userID, isEqualTo: currentUser.userID).getDocuments()
                        
            result.documents.forEach { document in
                let tripData = document.data()
                let trip = Trip(userID: tripData[tripTableConstants.userID] as? String ?? "",
                                startDate: tripData[tripTableConstants.startDate] as? Date ?? Date(),
                                endDate: tripData[tripTableConstants.endDate] as? Date ?? Date(),
                                destination: tripData[tripTableConstants.destination] as? String ?? "",
                                description: tripData[tripTableConstants.description] as? String ?? "")
                trips.append(trip)
            }
            
            UserAuth.shared.user?.trips = trips
            
        } catch {
            throw UserError.DatabaseError.defaultError
        }
    }*/
}
