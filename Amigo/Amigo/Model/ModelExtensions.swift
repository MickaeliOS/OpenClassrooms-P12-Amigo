//
//  ModelExtensions.swift
//  Amigo
//
//  Created by Mickaël Horn on 12/04/2023.
//

import Foundation
import MapKit

// MARK: - MODEL EXTENSIONS
extension Date {
    func dateToString(locale: Locale = Locale.current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: self)
    }
}

extension MKLocalSearch {
    static func getPartsFromAddress(address: String, completion: @escaping (MKMapItem?, Error?) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = address
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if error != nil {
                completion(nil, Errors.CommonError.defaultError)
                return
            }
            
            // I return the first element of the collection, because an address is unique.
            completion(response?.mapItems.first, nil)
        }
    }
}

extension String {
    static func countryFlag(countryCode: String) -> String? {
        if !Locale.isoRegionCodes.contains(countryCode) {
            return nil
        }
        
        return String(String.UnicodeScalarView(
            countryCode.unicodeScalars.compactMap(
                { UnicodeScalar(127397 + $0.value) })))
    }
}

extension Locale {
    static var countryList: [String] {
        Locale.isoRegionCodes.compactMap { Locale.current.localizedString(forRegionCode: $0) }
    }
    
    static func countryCode(forCountryName name: String) -> String? {
        for code in Locale.isoRegionCodes {
            if let countryName = Locale.current.localizedString(forRegionCode: code) {
                if countryName.lowercased() == name.lowercased() {
                    return code
                }
            }
        }
        return nil
    }
}
