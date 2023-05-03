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
    var description: String
    var womanOnly: Bool?
    var destination: Destination
    
    // User is optional so when we decode a Trip from Firestore,
    // it doesn't crash since the Firestore Table doesn't have a User.
    var user: User?

    /*func getUser() {
        guard let user = user else { return }
        
        //TODO: Fetch l'user, mais ça va à l'encontre du MVC d'utiliser une méthode d'un autre Model alors que je suis déjà dans un Model
    }*/
}

protocol FirestoreTrip {
    var userID: String { get }
    var startDate: Date { get }
    var endDate: Date { get }
    var description: String { get }
    var womanOnly: Bool? { get }
    var destination: Destination { get }
}
