//
//  PictureService.swift
//  Amigo
//
//  Created by Mickaël Horn on 26/04/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class PictureService {
    // MARK: - PROPERTIES & INIT
    private let userTableConstants = Constant.FirestoreTables.User.self
    private let firestoreDatabase: Firestore
    private let firebaseStorage: StorageReference

    init(firestoreDatabase: Firestore = Firestore.firestore(), firebaseStorage: StorageReference = Storage.storage().reference()) {
        self.firestoreDatabase = firestoreDatabase
        self.firebaseStorage = firebaseStorage
    }
    
    // MARK: - FUNCTIONS
    func uploadPicture(picture: Data, type: String) async throws -> String {
        //TODO: Attention, quand on upload une photo sans avoir mis de taille maximale, quand on va la télécharger dans getImage(), on spécifie une taille de 5 Mo.
        //TODO: Il faudrait dire à l'utilisateur de pas dépasser 5 Mo, parce que s'il upload une photo de 10 Mo par exemple, et qu'il peut pas la récupérer dans
        //TODO: la fonction getImage() parce qu'elle est trop grosse, ça pose un problème.
        
        guard let currentUser = UserAuth.shared.user else {
            throw UserError.CommonError.noUser
        }
        
        let savingPath = "\(currentUser.userID)/images/\(type)"
        let fileRef = firebaseStorage.child(savingPath)

        do {
            let _ = try await fileRef.putDataAsync(picture)
            return savingPath
        } catch {
            throw UserError.DatabaseError.cannotUploadPicture
        }
    }
    
    func getImage(path: String) async throws -> Data {
        do {
            let result = try await firebaseStorage.child(path).data(maxSize: 5 * 1024 * 1024)
            return result
        } catch {
            throw UserError.DatabaseError.cannotGetPicture
        }
    }
}
