//
//  LocationManagement.swift
//  Amigo
//
//  Created by Mickaël Horn on 10/05/2023.
//

import Foundation
import MapKit

final class LocationManagement {
    static func sortLocationsByDateAscending(locations: [Location]) -> [Location] {
        var copiedLocations = locations
        copiedLocations.sort(by: { $0.endDate.compare($1.endDate) == .orderedAscending })
        return copiedLocations
    }
    
    static func filterLocationByRegion(region: String, completion: @escaping (MKCoordinateRegion?) -> Void) {
        CLGeocoder().geocodeAddressString(region) { result, error in
            if error != nil {
                completion(nil)
                return
            }
            
            guard let result = result?.first,
                  let circularRegion = result.region as? CLCircularRegion else {
                completion(nil)
                return
            }
            
            let center = circularRegion.center
            let radius = circularRegion.radius
            let coordinateRegion = MKCoordinateRegion(center: center, latitudinalMeters: radius, longitudinalMeters: radius)
            
            completion(coordinateRegion)
        }
        
    }
}
