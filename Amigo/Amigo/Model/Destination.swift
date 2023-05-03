//
//  Destination.swift
//  Amigo
//
//  Created by Mickaël Horn on 03/05/2023.
//

import Foundation

struct Destination: FirestoreDestination {
    var country: String
    var address: String?
    var postalCode: Int?
    var city: String?
}

protocol FirestoreDestination {
    var country: String { get }
    var address: String? { get }
    var postalCode: Int? { get }
    var city: String? { get }
}
