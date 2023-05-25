//
//  MockCLGeocoder.swift
//  AmigoTests
//
//  Created by Mickaël Horn on 23/05/2023.
//

import Foundation
import MapKit

class CLGeocoderMock: CLGeocoder {
    
    // This Mock will ensure that we test the case where [CLPlacemark]? is nil, inside the getCoordinatesFromRegion() func.
    override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
        completionHandler(nil, nil)
    }
}
