//
//  AuthService.swift
//  Amigo
//
//  Created by Mickaël Horn on 11/04/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    public static let shared = AuthService()
    private init() {}
    
    func createUser(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard result?.user != nil else {
                completion(false, nil)
                return
            }
        }
    }
    
    func saveUserInDatabase(user: User, completion: @escaping (Bool, Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            //TODO: Erreur, pas de currentUser
            return
        }
        
        let database = Firestore.firestore()
        let userData = ["userID": currentUser.uid,
                        "email": currentUser.email,
                        "lastname": user.lastname,
                        "firstname": user.firstname,
                        "gender": user.gender.rawValue]
        
        database.collection("User").document(currentUser.uid).setData(userData) { [weak self] error in
            guard error == nil else {
                //TODO: Erreur lors de la sauvegarde
                completion(false, error)
                return
            }
            
            completion(true, nil)
        }
    }
}
