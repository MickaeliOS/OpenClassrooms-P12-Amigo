//
//  UserAuth.swift
//  Amigo
//
//  Created by Mickaël Horn on 11/04/2023.
//

import Foundation
import FirebaseAuth

class UserAuth {
    // MARK: - SINGLETON
    static let shared = UserAuth()
    private init() {}
    
    // MARK: - USER
    var user: User?
    var currentUser: FirebaseAuth.User? {
        Auth.auth().currentUser
    }
    var currentlyLoggedIn: Bool {
        Auth.auth().currentUser != nil
    }
}
