//
//  FirebaseManager.swift
//  Amigo
//
//  Created by Mickaël Horn on 11/04/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseManager {
    
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
            completion(true, nil)
        }
    }
    
    func saveUserInDatabase(user: User, completion: @escaping (Bool, Error?) -> Void) {
        let database = Firestore.firestore()
        let userData = ["userID": user.userID,
                        "email": user.email,
                        "lastname": user.lastname,
                        "firstname": user.firstname,
                        "gender": user.gender.rawValue]
        
        database.collection("User").document(user.userID).setData(userData) { error in
            guard error == nil else {
                //TODO: Erreur lors de la sauvegarde
                print("MKA - ERROR DB")
                completion(false, error)
                return
            }
            print("MKA - OK DB")

            completion(true, nil)
        }
    }
    
    func fetchUser(completion: @escaping (User?) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        Firestore.firestore().collection("User").document(currentUserID).getDocument { snapshot, error in
            if let _ = error {
                //TODO: Handle Error
                completion(nil)
                return
            }
            
            guard let data = snapshot?.data() else {
                //TODO: Handle no data
                completion(nil)
                return
            }
            
            let genderString = data["gender"] as? String ?? ""
            let gender = User.Gender(rawValue: genderString) ?? .woman

            let user = User(
                userID: data["userID"] as? String ?? "",
                firstname: data["firstname"] as? String ?? "",
                lastname: data["lastname"] as? String ?? "",
                gender: gender,
                email: data["email"] as? String ?? ""
            )
            
            completion(user)
        }
    }
}
