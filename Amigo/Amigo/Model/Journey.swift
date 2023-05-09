//
//  Journey.swift
//  Amigo
//
//  Created by Mickaël Horn on 09/05/2023.
//

import Foundation
import FirebaseFirestoreSwift

struct Journey: Codable {
    @DocumentID var tripID: String?
    
    // While it is expected for a Journey to contain at least one Location,
    // in order to prevent decoding errors from Firestore, we have marked the location property as optional.
    var locations: [Location]?
}
