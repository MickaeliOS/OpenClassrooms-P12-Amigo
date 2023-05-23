//
//  Location.swift
//  Amigo
//
//  Created by Mickaël Horn on 23/05/2023.
//

import Foundation

struct Location: Equatable, Codable {
    var address: String
    var postalCode: String
    var city: String
    var startDate: Date
    var endDate: Date
}
