//
//  User.swift
//  Amigo
//
//  Created by Mickaël Horn on 11/04/2023.
//

import Foundation

struct User {
    var userID: String
    var firstname: String
    var lastname: String
    var gender: Gender
    var email: String
    var description: String?
    var globalNote: Double?
    var profilePicture: ImageInfos?
    var banner: ImageInfos?
    
    enum Gender: String {
        case man = "Man"
        case woman = "Woman"
    }
}

struct ImageInfos {
    var image: String?
    var data: Data?
}
