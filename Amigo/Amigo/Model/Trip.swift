//
//  Trip.swift
//  Amigo
//
//  Created by Mickaël Horn on 27/04/2023.
//

import Foundation

struct Trip: Codable, FirestoreTrip {
    var userID: String
    var startDate: Date
    var endDate: Date
    var destination: Destination
    
    // User is optional so when we decode a Trip from Firestore,
    // it doesn't crash since the Firestore Table doesn't have a User.
    var user: User?
}

protocol FirestoreTrip {
    var userID: String { get }
    var startDate: Date { get }
    var endDate: Date { get }
    var destination: Destination { get }
}
