//
//  Trip.swift
//  Amigo
//
//  Created by Mickaël Horn on 27/04/2023.
//

import Foundation

struct Trip: Codable {
    var userID: String
    var startDate: Date
    var endDate: Date
    var destination: String
    var description: String
    var womanOnly: Bool?
}
