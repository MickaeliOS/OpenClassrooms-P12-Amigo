//
//  UserService.swift
//  Amigo
//
//  Created by Mickaël Horn on 14/04/2023.
//

import Foundation
import FirebaseAuth

final class UserService {
    static let shared = UserService()
    private init() {}
    
    var user: User?
    var currentlyLoggedIn: Bool {
        Auth.auth().currentUser != nil
    }

        
    /*func loginFlow(completion: @escaping (Bool) -> Void) {
        handle = Auth.auth().addStateDidChangeListener { (_, cachedUser) in
            guard let cachedUser = cachedUser else {
                UserService.shared.currentlyLoggedIn = false
                completion(false)
                return
            }
            
            UserService.shared.currentlyLoggedIn = true
            FirebaseManager().fetchUser(uid: cachedUser.uid) { user in
                guard let user = user else {
                    return
                }

                UserService.shared.user = user
                completion(true)
            }
        }
    }*/

}
