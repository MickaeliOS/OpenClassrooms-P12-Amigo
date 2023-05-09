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
}
