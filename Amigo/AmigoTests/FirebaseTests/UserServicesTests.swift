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
    private var firebaseMock: FirebaseMock!
    private var userCreationService: UserCreationService!
    
    override func setUp() {
        super.setUp()
        firebaseMock = FirebaseMock()
        userCreationService = UserCreationService(firebaseWrapper: firebaseMock)
    }
    
    // MARK: - UTILITIES FUNC
    
    // MARK: - UserCreationService.swift
    func testGivenIncorrectEmail_WhenCreatingUser_ThenBadlyFormattedEmailError() async {
        let incorrectEmail = "testtest.com"
        
        do {
            try await userCreationService.createUser(email: incorrectEmail,
                                                     password: "",
                                                     confirmPassword: "")
            
            XCTFail("Test failed, expected to throw but passed.")
        } catch let error as Errors.CommonError {
            XCTAssertEqual(error.localizedDescription, "Badly formatted email, please provide a correct one.")
        } catch {
            XCTFail("Test failed, expected to be Errors.CommonError type.")
        }
    }
    
    func testGivenIncorrectPassword_WhenCreatingUser_ThenWeakPasswordError() async {
        let correctEmail = "test@test.com"
        let incorrectPassword = "123"
        
        do {
            try await userCreationService.createUser(email: correctEmail,
                                                     password: incorrectPassword,
                                                     confirmPassword: "")
            
            XCTFail("Test failed, expected to throw but passed.")
        } catch let error as Errors.CreateAccountError {
            XCTAssertEqual(error.localizedDescription, "Your password is too weak. It must be : \n - At least 7 characters long \n - At least one uppercase letter \n - At least one number")
        } catch {
            XCTFail("Test failed, expected to be Errors.CreateAccountError type.")
        }
    }
    
    
    func testGivenDifferentPasswords_WhenCreatingUser_ThenPasswordsNotEqualsError() async {
        let correctEmail = "test@test.com"
        let correctPassword = "pmpmpmP0"
        let incorrectConfirmationPassword = "123"

        do {
            try await userCreationService.createUser(email: correctEmail,
                                                     password: correctPassword,
                                                     confirmPassword: incorrectConfirmationPassword)
            
            XCTFail("Test failed, expected to throw but passed.")
        } catch let error as Errors.CreateAccountError {
            XCTAssertEqual(error.localizedDescription, "Passwords must be equals.")
        } catch {
            XCTFail("Test failed, expected to be Errors.CreateAccountError type.")
        }
    }
    
    func testGivenEmailAlreadyInUseError_WhenCreatingUser_ThenCustomEmailAlreadyInUseError() async {
        // I'm telling the Mock that I want createUser() to fail, and I provide the error i want.
        firebaseMock.createUserSuccess = false
        let errorCode = AuthErrorCode.emailAlreadyInUse.rawValue
        firebaseMock.createUserError = NSError(domain: "", code: errorCode, userInfo: nil)
        
        let correctEmail = "test@test.com"
        let correctPassword = "pmpmpmP0"
        let correctConfirmationPassword = "pmpmpmP0"
        
        do {
            try await userCreationService.createUser(email: correctEmail,
                                                     password: correctPassword,
                                                     confirmPassword: correctConfirmationPassword)
            
            XCTFail("Test failed, expected to throw but passed.")
        } catch let error as Errors.CreateAccountError {
            XCTAssertEqual(error.localizedDescription, "Email already in use. Please choose a different one.")
        } catch {
            XCTFail("Test failed, expected to be Errors.CreateAccountError type.")
        }
    }
    
    func testGivenCorrectInformations_WhenCreatingUser_ThenUserIsCreated() async {
        let correctEmail = "test@test.com"
        let correctPassword = "pmpmpmP0"
        let correctConfirmationPassword = "pmpmpmP0"
        
        do {
            try await userCreationService.createUser(email: correctEmail,
                                                     password: correctPassword,
                                                     confirmPassword: correctConfirmationPassword)
            
            // If there is no throw, test succeeded.
            // However, I cant' use XCTAssertNoThrow(), because 'async' call in an autoclosure does not support concurrency.
        } catch {
            XCTFail("Test failed, did not expected to throw.")
        }
    }
}
