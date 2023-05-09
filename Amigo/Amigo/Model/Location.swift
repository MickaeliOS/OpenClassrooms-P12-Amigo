//
//  Location.swift
//  Amigo
//
//  Created by Mickaël Horn on 03/05/2023.
//

import Foundation

struct Location: Equatable, Codable {
    var address: String
    var postalCode: String
    var city: String
    var startDate: Date
    var endDate: Date
}

extension Location {
    // It's impossible to update a custom Array in Firestore.
    // I have to convert it into a [String:Any].
    var firestoreLocation: [String: Any] {
        return [
            "address": address,
            "postalCode": postalCode,
            "city": city,
            "startDate": startDate,
            "endDate": endDate
        ]
    }
}
