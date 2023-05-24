//
//  UserServicesTests.swift
//  AmigoTests
//
//  Created by Mickaël Horn on 18/05/2023.
//

import XCTest
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
@testable import Amigo

final class UserServicesTests: XCTestCase {
    private let userCreationService = UserCreationService()
    private let userFetchingService = UserFetchingService()


    /*override class func setUp() {
        <#code#>
    }*/
    
    // MARK: - UTILITIES FUNC
    func clearFirestore() {
      let semaphore = DispatchSemaphore(value: 0)
      let projectId = FirebaseApp.app()!.options.projectID!
      let url = URL(string: "http://localhost:8080/emulator/v1/projects/\(projectId)/databases/(default)/documents")!
      var request = URLRequest(url: url)
      request.httpMethod = "DELETE"
      let task = URLSession.shared.dataTask(with: request) { _,_,_ in
        print("Firestore cleared")
        semaphore.signal()
      }
      task.resume()
      semaphore.wait()
    }
    
    // MARK: - UserCreationService.swift
    func testGivenIncorrectEmail_WhenCreatingUser_ThenUserIsNotCreatedAndErrorReturns() async {
        let email = "testexample.com"
        let password = "pmpmpmP0"
        let confirmPassword = "pmpmpmP0"
        
        do {
            try await userCreationService.createUser(email: email, password: password, confirmPassword: confirmPassword)
            XCTFail("Expected to throw while awaiting, but succeeded")

        } catch {
            XCTAssertEqual(error as? Errors.CommonError, .badlyFormattedEmail)
        }
    }
    
    func testGivenIncorrectPassword_WhenCreatingUser_ThenUserIsNotCreatedAndErrorReturns() async {
        let email = "test@example.com"
        let password = "1234"
        let confirmPassword = "pmpmpmP0"
        
        do {
            try await userCreationService.createUser(email: email, password: password, confirmPassword: confirmPassword)
            XCTFail("Expected to throw while awaiting, but succeeded")

        } catch {
            XCTAssertEqual(error as? Errors.CreateAccountError, .weakPassword)
        }
    }
    
    func testGivenIncorrectConfirmationPassword_WhenCreatingUser_ThenUserIsNotCreatedAndErrorReturns() async {
        let email = "test@example.com"
        let password = "pmpmpmP0"
        let confirmPassword = "pmpmpmP0000"
        
        do {
            try await userCreationService.createUser(email: email, password: password, confirmPassword: confirmPassword)
            XCTFail("Expected to throw while awaiting, but succeeded")

        } catch {
            XCTAssertEqual(error as? Errors.CreateAccountError, .passwordsNotEquals)
        }
    }
    
    
    func testGivenCorrectLogs_WhenCreatingUser_ThenUserIsCreated() async {
        let email = "test@example.com"
        let password = "pmpmpmP0"
        let confirmPassword = "pmpmpmP0"
        
        do {
            try await userCreationService.createUser(email: email, password: password, confirmPassword: confirmPassword)
            
            // Checking if the user has been created.
            let currentUser = Auth.auth().currentUser
            XCTAssertNotNil(currentUser)
                        
        } catch {
            // The test shouldn't pass by the catch, so it fails.
            XCTFail("Error during the user creation process : \(error)")
        }
    }
    
    func testGivenAUser_WhenTryingToSaveInFirestore_ThenUserErrorIsStored() async {
        let user = User(email: "test@example.com")
        
        do {
            try await userCreationService.saveUserInDatabase(user: user, userID: "1234")
            
            // I have to be sure the user exists after creation.
            let user = try await userFetchingService.fetchUser(userID: "1234")
            XCTAssertNotNil(user)
            clearFirestore()
            
        } catch {
            XCTFail("Test failed, was not expected to throw.")
        }
    }

    
}
