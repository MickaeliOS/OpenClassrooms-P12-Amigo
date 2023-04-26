//
//  FirebaseManager.swift
//  Amigo
//
//  Created by Mickaël Horn on 26/04/2023.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

final class FirebaseManager {
    let firestoreDatabase: Firestore
    let firebaseStorage: StorageReference
    let firebaseAuth: Auth
    
    init(firestoreDatabase: Firestore = Firestore.firestore(),
         firebaseStorage: StorageReference = Storage.storage().reference(),
         firebaseAuth: Auth = Auth.auth()) {
        
        self.firestoreDatabase = firestoreDatabase
        self.firebaseStorage = firebaseStorage
        self.firebaseAuth = firebaseAuth
    }
}
