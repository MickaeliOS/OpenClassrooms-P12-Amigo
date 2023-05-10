//
//  LocationManagement.swift
//  Amigo
//
//  Created by Mickaël Horn on 10/05/2023.
//

import Foundation

final class LocationManagement {
    static func sortLocationsByDateAscending(locations: [Location]) -> [Location] {
        var copiedLocations = locations
        copiedLocations.sort(by: { $0.endDate.compare($1.endDate) == .orderedAscending })
        return copiedLocations
    }
}
