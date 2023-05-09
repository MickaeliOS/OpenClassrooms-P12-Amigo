//
//  Trip.swift
//  Amigo
//
//  Created by Mickaël Horn on 27/04/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct Trip: Codable, Equatable, FirestoreTrip {
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        return lhs.tripID == rhs.tripID
        && lhs.userID == rhs.userID
        && lhs.startDate == rhs.startDate
        && lhs.endDate == rhs.endDate
        && lhs.country == rhs.country
        && lhs.countryCode == rhs.countryCode
        && lhs.journeyList == rhs.journeyList
    }
    
    @DocumentID var tripID: String?
    var userID: String
    var startDate: Date
    var endDate: Date
    var country: String
    var countryCode: String
    var journeyList: [Journey]?
}

protocol FirestoreTrip {
    var userID: String { get }
    var startDate: Date { get }
    var endDate: Date { get }
    var country: String { get }
    var countryCode: String { get }
    var journeyList: [Journey]? { get }
}
