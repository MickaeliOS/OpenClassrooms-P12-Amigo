//
//  LocationManagement.swift
//  Amigo
//
//  Created by Mickaël Horn on 10/05/2023.
//

import Foundation
import MapKit

final class LocationManagement {
    var geocoder: CLGeocoder
    
    init(geocoder: CLGeocoder = CLGeocoder()) {
        self.geocoder = geocoder
    }
    
    static func sortLocationsByDateAscending(locations: [Location]) -> [Location] {
        var copiedLocations = locations
        copiedLocations.sort(by: { $0.endDate.compare($1.endDate) == .orderedAscending })
        return copiedLocations
    }
    
    func getCoordinatesFromRegion(region: String, completion: @escaping (MKCoordinateRegion?, Error?) -> Void) {
        geocoder.geocodeAddressString(region) { result, error in
            if error != nil {
                completion(nil, Errors.CommonError.defaultError)
                return
            }
            
            guard let result = result?.first,
                  let circularRegion = result.region as? CLCircularRegion else {
                completion(nil, nil)
                return
            }
            
            let center = circularRegion.center
            let radius = circularRegion.radius
            let coordinateRegion = MKCoordinateRegion(center: center, latitudinalMeters: radius, longitudinalMeters: radius)
            
            completion(coordinateRegion, nil)
        }
    }
}
