//
//  FirebaseWrapper.swift
//  Amigo
//
//  Created by Mickaël Horn on 25/05/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

// MARK: - PROTOCOL
    /// This protocol contains all the Firebase related functions the project will use.
    /// It will be really useful for Mocking Firebase later.

protocol FirebaseProtocol {
    func signIn(email: String, password: String) async throws
    func signOut() throws
    func createUser(withEmail: String, password: String) async throws
    func saveUserInDatabase(userID: String, fields: [String: Any]) async throws
    func fetchUser(userID: String) async throws -> User?
    func updateUser(fields: [String:Any], userID: String) async throws
    func createTrip(trip: Trip) throws -> String
    func fetchTrips(userID: String) async throws -> [Trip]


}

// MARK: - PROTOCOLS
    /// Inside the Wrapper, we write the classics Firebase functions.
    /// These functions does not need to be tested, because it is already done
    /// by Firebase.

final class FirebaseWrapper: FirebaseProtocol {
    func signIn(email: String, password: String) async throws {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            throw error
        }
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw error
        }
    }

    func createUser(withEmail: String, password: String) async throws {
        do {
            try await Auth.auth().createUser(withEmail: withEmail, password: password)
        } catch {
            throw error
        }
    }
    
    func saveUserInDatabase(userID: String, fields: [String: Any]) async throws {
        do {
            try await Firestore.firestore().collection(Constant.FirestoreTables.User.tableName).document(userID).setData(fields)
        } catch {
            throw error
        }
    }
    
    func fetchUser(userID: String) async throws -> User? {
        do {
            let documentSnapshot = try await Firestore.firestore().collection(Constant.FirestoreTables.User.tableName).document(userID).getDocument()
            
            // First, we ensure the existence of the user before proceeding.
            guard documentSnapshot.exists else {
                return nil
            }
            
            // If the user is found, we proceed with decoding and returning the corresponding user object.
            return try documentSnapshot.data(as: User.self)
            
        } catch {
            throw error
        }
    }
    
    func updateUser(fields: [String : Any], userID: String) async throws {
        do {
            try await Firestore.firestore().collection(Constant.FirestoreTables.User.tableName).document(userID).updateData(fields)
        } catch {
            throw error
        }
    }
    
    func createTrip(trip: Trip) throws -> String {
        do {
            let docRef = try Firestore.firestore().collection(Constant.FirestoreTables.Trip.tableName).addDocument(from: trip.self)
            return docRef.documentID
        } catch {
            throw error
        }
    }
    
    func fetchTrips(userID: String) async throws -> [Trip] {
        var trips: [Trip] = []

        do {
            // We need the user's trips, each trip we fetch must have the same userID
            let result = try await Firestore.firestore().collection(Constant.FirestoreTables.Trip.tableName).whereField(Constant.FirestoreTables.Trip.userID, isEqualTo: userID).getDocuments()
            
            // Transforming the [QueryDocumentSnapshot] with Codable
            try result.documents.forEach { document in
                let trip = try document.data(as: Trip.self)
                trips.append(trip)
            }
            
            return trips
        } catch {
            throw error
        }
    }

}
