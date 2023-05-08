//
//  Destination.swift
//  Amigo
//
//  Created by Mickaël Horn on 03/05/2023.
//

import Foundation

struct Destination: FirestoreDestination, Codable {
    // A destination, at least, have a country and a countryCode.
    var country: String
    var countryCode: String
    var address: String?
    var postalCode: String?
    var city: String?
}

protocol FirestoreDestination {
    var country: String { get }
    var countryCode: String { get }
    var address: String? { get }
    var postalCode: String? { get }
    var city: String? { get }
}
