//
//  Destination.swift
//  Amigo
//
//  Created by Mickaël Horn on 03/05/2023.
//

import Foundation

struct Journey: FirestoreJourney, Equatable, Codable {
    var address: String
    var postalCode: String
    var city: String
    var startDate: Date
    var endDate: Date
}

protocol FirestoreJourney {
    var address: String { get }
    var postalCode: String { get }
    var city: String { get }
    var startDate: Date { get }
    var endDate: Date { get }
}
