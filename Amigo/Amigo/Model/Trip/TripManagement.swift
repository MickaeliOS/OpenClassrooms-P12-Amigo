//
//  TripManagement.swift
//  Amigo
//
//  Created by Mickaël Horn on 10/05/2023.
//

import Foundation

final class TripManagement {
    static func sortTripsByDateAscending(trips: [Trip]) -> [Trip] {
        var copiedTrips = trips
        copiedTrips.sort(by: { $0.endDate.compare($1.endDate) == .orderedAscending })
        return copiedTrips
    }
}
