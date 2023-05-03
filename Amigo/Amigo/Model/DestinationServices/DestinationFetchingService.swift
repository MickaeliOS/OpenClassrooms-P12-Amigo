//
//  DestinationFetchingService.swift
//  Amigo
//
//  Created by Mickaël Horn on 03/05/2023.
//

import Foundation
import FirebaseFirestore

/*class DestinationFetchingService {
    // MARK: - PROPERTIES & INIT
    private let destinationTableConstants = Constant.FirestoreTables.Destination.self
    private let firestoreDatabase: Firestore
    
    init(firestoreDatabase: Firestore = Firestore.firestore()) {
        self.firestoreDatabase = firestoreDatabase
    }
    
    func fetchTripsDestinations(trips: [Trip]) async throws -> Destination {
       //TODO: Gérer proprement les erreurs
       guard let _ = UserAuth.shared.user else {
           throw UserError.CommonError.noUser
       }
               
       do {
           
           trips.forEach { trip in
               // We need the trip's destination
               let destinationTable = firestoreDatabase.collection(destinationTableConstants.tableName)
               let query = destinationTable.document(tripID)
               
               let destination = try await query.getDocument(as: Destination.self)
               
               return destination
           }

       } catch {
           throw UserError.DatabaseError.defaultError
       }
   }
}*/
