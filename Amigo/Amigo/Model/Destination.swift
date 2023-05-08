//
//  Destination.swift
//  Amigo
//
//  Created by Mickaël Horn on 03/05/2023.
//

import Foundation

struct Destination: FirestoreDestination, Codable {
    var address: String?
    var postalCode: String?
    var city: String?
}

protocol FirestoreDestination {
    var address: String? { get }
    var postalCode: String? { get }
    var city: String? { get }
}
