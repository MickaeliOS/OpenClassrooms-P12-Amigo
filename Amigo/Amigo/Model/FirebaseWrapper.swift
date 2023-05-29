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
    func updateTrip(with tripID: String, fields: [String:Any]) async throws
    func deleteTrip(tripID: String) async throws
    func fetchTripJourney(tripID: String, completion: @escaping (Journey?, Error?) -> Void)
    func updateJourney(journey: Journey, for tripID: String) throws
    func deleteJourney(tripID: String) async throws
    func updateExpense(expenses: Expense, for tripID: String) throws


}

// MARK: - PROTOCOLS
    /// Inside the Wrapper, we write the classics Firebase functions.
    /// These functions does not need to be tested, because it is already done
    /// by Firebase.

final class FirebaseWrapper: FirebaseProtocol {
    
    // MARK: - USER AUTH FUNCTIONS
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
    
    // MARK: - USER FIRESTORE FUNCTIONS
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
    
    // MARK: - TRIP FIRESTORE FUNCTIONS
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

    func updateTrip(with tripID: String, fields: [String : Any]) async throws {
        do {
            try await Firestore.firestore().collection(Constant.FirestoreTables.Trip.tableName).document(tripID).updateData(fields)
        } catch {
            throw error
        }
    }
    
    func deleteTrip(tripID: String) async throws {
        do {
            try await Firestore.firestore().collection(Constant.FirestoreTables.Trip.tableName).document(tripID).delete()
        } catch {
            throw error
        }
    }
    
    // MARK: - JOURNEY FIRESTORE FUNCTIONS
    func fetchTripJourney(tripID: String, completion: @escaping (Journey?, Error?) -> Void) {
        Firestore.firestore().collection(Constant.FirestoreTables.Journey.tableName).document(tripID).getDocument { docSnapshot, error in
            if error != nil {
                completion(nil, error)
                return
            }
            
            // If the document exists, we should convert it into a Journey Object.
            if let document = docSnapshot, document.exists {
                let convertedJourney = try? document.data(as: Journey.self)
                completion(convertedJourney, nil)
                return
            }
            
            completion(nil, nil)
        }
    }
    
    func updateJourney(journey: Journey, for tripID: String) throws {
        do {
            try Firestore.firestore().collection(Constant.FirestoreTables.Journey.tableName).document(tripID).setData(from: journey.self)
        } catch {
            throw error
        }
    }
    
    func deleteJourney(tripID: String) async throws {
        do {
            try await Firestore.firestore().collection(Constant.FirestoreTables.Journey.tableName).document(tripID).delete()
        } catch {
            throw error
        }
    }
    
    // MARK: - JOURNEY FIRESTORE FUNCTIONS
    func updateExpense(expenses: Expense, for tripID: String) throws {
        do {
            try Firestore.firestore().collection(Constant.FirestoreTables.Expense.tableName).document(tripID).setData(from: expenses.self)
        } catch {
            throw error
        }
    }
}
