//
//  User.swift
//  Amigo
//
//  Created by Mickaël Horn on 11/04/2023.
//

import Foundation

struct User: Codable {
    var firstname: String
    var lastname: String
    var gender: Gender
    var email: String
    var trips: [Trip]?
    
    enum Gender: String, Codable {
        case woman = "Woman"
        case man = "Man"
        
        static func index(of gender: Gender) -> Int {
            let elements = [Gender.woman, Gender.man]
            return elements.firstIndex(of: gender)!
        }
    }
}
