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
    func dateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: self)
        
        return dateString
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
            }
            
            guard let mapItems = response?.mapItems, !mapItems.isEmpty else {
                completion(nil, nil)
                return
            }
            
            // I return the first element of the collection, because an address is unique.
            completion(mapItems.first, nil)
        }
    }
}

extension String {
    static func countryFlag(countryCode: String) -> String {
        return String(String.UnicodeScalarView(
            countryCode.unicodeScalars.compactMap(
                { UnicodeScalar(127397 + $0.value) })))
    }
    
    static func emptyControl(fields: [String?]) -> Bool {
        for field in fields {
            guard let field = field, !field.isEmpty else {
                return false
            }
        }
        return true
    }
}

extension Locale {
    static var countryList: [String] {
        Locale.isoRegionCodes.compactMap { Locale.current.localizedString(forRegionCode: $0) }
    }
    
    static func countryCode(forCountryName name: String) -> String? {
        for code in Locale.isoRegionCodes {
            guard let countryName = Locale.current.localizedString(forRegionCode: code) else {
                continue
            }
            if countryName.lowercased() == name.lowercased() {
                return code
            }
        }
        return nil
    }
}
