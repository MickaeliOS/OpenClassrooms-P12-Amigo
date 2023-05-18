//
//  UserTests.swift
//  AmigoTests
//
//  Created by Mickaël Horn on 18/05/2023.
//

import XCTest
import FirebaseAuth
@testable import Amigo

final class UserTests: XCTestCase {
    
    func testGivenCorrectLogs_WhenCreatingUser_ThenUserIsCreated() async {
        let auth = Auth.auth()
        let userCreationService = UserCreationService()
        let expectation = XCTestExpectation(description: "User creation")
        
        let email = "test@example.com"
        let password = "pmpmpmP0"
        let confirmPassword = "pmpmpmP0"
        
        do {
            try await userCreationService.createUser(email: email, password: password, confirmPassword: confirmPassword)
            
            // Vérifier si l'utilisateur a été créé avec succès
            let currentUser = auth.currentUser
            XCTAssertNotNil(currentUser)
            
            // Ajoutez des assertions supplémentaires si nécessaire
            
            expectation.fulfill()
        } catch {
            // Échec du test
            XCTFail("Erreur lors de la création de l'utilisateur : \(error)")
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
