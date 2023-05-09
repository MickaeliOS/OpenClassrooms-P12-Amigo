//
//  DestinationCreationService.swift
//  Amigo
//
//  Created by Mickaël Horn on 03/05/2023.
//

import Foundation
import FirebaseFirestore

/*class DestinationCreationService {
    // MARK: - PROPERTIES & INIT
    private let destinationTableConstants = Constant.FirestoreTables.Destination.self
    private let firestoreDatabase: Firestore
    
    init(firestoreDatabase: Firestore = Firestore.firestore()) {
        self.firestoreDatabase = firestoreDatabase
    }
    // MARK: - FUNCTIONS
    func createDestination(destination: Destination) throws -> String {
        guard let _ = UserAuth.shared.user else {
            throw UserError.DatabaseError.defaultError
        }

        do {
            let result = try firestoreDatabase.collection(destinationTableConstants.tableName).addDocument(from: destination.self)
            
            // Once the destination is created, I need to pass the documentID in order to add the Trip
            return result.documentID
        } catch {
            throw UserError.DatabaseError.defaultError
        }
    }
}
*/
