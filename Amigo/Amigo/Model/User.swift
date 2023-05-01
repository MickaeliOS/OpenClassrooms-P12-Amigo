//
//  User.swift
//  Amigo
//
//  Created by Mickaël Horn on 11/04/2023.
//

import Foundation

struct User: Codable {
    var userID: String
    var firstname: String
    var lastname: String
    var gender: Gender
    var email: String
    var description: String?
    var profilePicture: ImageInfos?
    var banner: ImageInfos?
    
    enum Gender: String, Codable {
        case man = "Man"
        case woman = "Woman"
    }
}

struct ImageInfos: Codable {
    var image: String?
    var data: Data?
}
