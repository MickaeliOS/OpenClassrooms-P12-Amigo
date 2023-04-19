//
//  Constant.swift
//  Amigo
//
//  Created by Mickaël Horn on 19/04/2023.
//

import Foundation

struct Constant {
    
    struct FirestoreTables {
        
        struct User {
            static let tableName = "User"
            
            static let userID = "userID"
            static let firstname = "firstname"
            static let lastname = "lastname"
            static let gender = "gender"
            static let email = "email"
            static let description = "description"
            static let globalNote = "globalNote"
            static let profilePicture = "profilePicture"
            static let banner = "banner"
        }
    }
}
