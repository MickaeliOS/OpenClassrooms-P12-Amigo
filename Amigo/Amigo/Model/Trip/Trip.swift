//
//  Trip.swift
//  Amigo
//
//  Created by Mickaël Horn on 27/04/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct Trip: Codable, Equatable {
    @DocumentID var tripID: String?
    var userID: String
    var startDate: Date
    var endDate: Date
    var country: String
    var countryCode: String
    var toDoList: [String]?
    //var journey: [Location]?
}
