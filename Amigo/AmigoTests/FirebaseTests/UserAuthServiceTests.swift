//
//  UserAuthServiceTests.swift
//  AmigoTests
//
//  Created by Mickaël Horn on 18/05/2023.
//

import XCTest
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
@testable import Amigo

final class UserAuthServiceTests: XCTestCase {
    
    // MARK: - MOCK AND MODEL
    private var firebaseMock: FirebaseMock!
    private var userAuthService: UserAuthService!
    
    // MARK: - PROPERTIES
    private var correctEmail = "test@test.com"
    private var incorrectEmail = "testtest.com"
    
    private var correctPassword = "pmpmpmP0"
    private var incorrectPassword = "pmpmpmp0"
    
    private var correctConfirmPassword = "pmpmpmP0"
    private var incorrectConfirmPassword = "pmpmpmp0"
    
    // MARK: - UTILITIES FUNC
    override func setUp() {
        super.setUp()
        firebaseMock = FirebaseMock()
        userAuthService = UserAuthService(firebaseWrapper: firebaseMock)
    }
    
    // MARK: - SIGNIN TESTS
    func testGivenBadFormattedEmail_WhenSignIn_ThenBadlyFormattedEmailError() async {
        do {
            try await userAuthService.signIn(email: incorrectEmail, password: correctPassword)
            XCTFail("Test failed, expected to throw but passed.")
            
        } catch let error as Errors.CommonError {
            // Sometimes, the mock may not be triggered because it is unnecessary.
            // This can occur when certain checks or validations are performed before executing the mocked function, and if those checks determine that an error should be thrown, the mock function is bypassed.
            XCTAssertFalse(firebaseMock.signInTriggered)
            XCTAssertEqual(error, .badlyFormattedEmail)
            XCTAssertEqual(error.localizedDescription, "Badly formatted email, please provide a correct one.")
        } catch {
            XCTFail("Test failed, expected to be Errors.CommonError type.")
        }
    }
    
    func testGivenBadEmail_WhenSignIn_ThenIncorrectLogsError() async {
        // I'm telling the Mock that I want signIn() to fail, and I provide the error i want.
        firebaseMock.success = false
        let errorCode = AuthErrorCode.userNotFound.rawValue
        firebaseMock.testNSError = NSError(domain: "", code: errorCode, userInfo: nil)
        
        do {
            try await userAuthService.signIn(email: correctEmail, password: correctPassword)
            XCTFail("Test failed, expected to throw but passed.")
            
        } catch let error as Errors.SignInError {
            // Controlling that we have the correct error.
            XCTAssertTrue(firebaseMock.signInTriggered)
            XCTAssertEqual(error, .incorrectLogs)
            XCTAssertEqual(error.localizedDescription, "Incorrect Email or Password.")
        } catch {
            XCTFail("Test failed, expected to be Errors.SignInError type.")
        }
    }
    
    func testGivenAnError_WhenSignIn_ThenDefaultError() async {
        firebaseMock.success = false
        
        do {
            try await userAuthService.signIn(email: correctEmail, password: correctPassword)
            XCTFail("Test failed, expected to throw but passed.")
            
        } catch let error as Errors.CommonError {
            XCTAssertTrue(firebaseMock.signInTriggered)
            XCTAssertEqual(error, .defaultError)
            XCTAssertEqual(error.localizedDescription, "Something went wrong, please try again.")
        } catch {
            XCTFail("Test failed, expected to be Errors.CommonError type.")
        }
    }
    
    func testGivenBadPassword_WhenSignIn_ThenIncorrectLogsError() async {
        firebaseMock.success = false
        let errorCode = AuthErrorCode.wrongPassword.rawValue
        firebaseMock.testNSError = NSError(domain: "", code: errorCode, userInfo: nil)
        
        do {
            try await userAuthService.signIn(email: correctEmail, password: correctPassword)
            XCTFail("Test failed, expected to throw but passed.")
            
        } catch let error as Errors.SignInError {
            XCTAssertTrue(firebaseMock.signInTriggered)
            XCTAssertEqual(error, .incorrectLogs)
            XCTAssertEqual(error.localizedDescription, "Incorrect Email or Password.")
        } catch {
            XCTFail("Test failed, expected to be Errors.SignInError type.")
        }
    }
    
    // MARK: - SIGNOUT TESTS
    func testGivenError_WhenLoginOut_ThenUserCannotLogOut() {
        firebaseMock.success = false
        
        do {
            try userAuthService.signOut()
            XCTFail("Test failed, expected to throw but passed.")
            
        } catch let error as Errors.SignOutError {
            XCTAssertTrue(firebaseMock.signOutTriggered)
            XCTAssertEqual(error, .cannotSignOut)
            XCTAssertEqual(error.localizedDescription, "Unable to log you out. Please restart the application and attempt the logout process again.")
        } catch {
            XCTFail("Test failed, expected to be Errors.SignOutError type.")
        }
    }
    
    func testGivenNoError_WhenLoginOut_ThenUserIsLoggedOut() {
        XCTAssertNoThrow(try userAuthService.signOut())
        XCTAssertTrue(firebaseMock.signOutTriggered)
    }
    
    // MARK: - CREATEUSER TESTS
    func testGivenBadlyFormattedEmail_WhenCreatingUser_ThenBadlyFormattedEmailError() async {
        do {
            try await userAuthService.createUser(email: incorrectEmail,
                                                 password: correctPassword,
                                                 confirmPassword: correctConfirmPassword)
            
            XCTFail("Test failed, expected to throw but passed.")
        } catch let error as Errors.CommonError {
            XCTAssertFalse(firebaseMock.createUserTriggered)
            XCTAssertEqual(error, .badlyFormattedEmail)
            XCTAssertEqual(error.localizedDescription, "Badly formatted email, please provide a correct one.")
        } catch {
            XCTFail("Test failed, expected to be Errors.CommonError type.")
        }
    }
    
    func testGivenIncorrectPassword_WhenCreatingUser_ThenWeakPasswordError() async {
        do {
            try await userAuthService.createUser(email: correctEmail,
                                                 password: incorrectPassword,
                                                 confirmPassword: correctConfirmPassword)
            
            XCTFail("Test failed, expected to throw but passed.")
        } catch let error as Errors.CreateAccountError {
            XCTAssertFalse(firebaseMock.createUserTriggered)
            XCTAssertEqual(error, .weakPassword)
            XCTAssertEqual(error.localizedDescription, "Your password is too weak. It must be : \n - At least 7 characters long \n - At least one uppercase letter \n - At least one number")
        } catch {
            XCTFail("Test failed, expected to be Errors.CreateAccountError type.")
        }
    }
    
    
    func testGivenDifferentPasswords_WhenCreatingUser_ThenPasswordsNotEqualsError() async {
        do {
            try await userAuthService.createUser(email: correctEmail,
                                                 password: correctPassword,
                                                 confirmPassword: incorrectConfirmPassword)
            
            XCTFail("Test failed, expected to throw but passed.")
        } catch let error as Errors.CreateAccountError {
            XCTAssertFalse(firebaseMock.createUserTriggered)
            XCTAssertEqual(error, .passwordsNotEquals)
            XCTAssertEqual(error.localizedDescription, "Passwords must be equals.")
        } catch {
            XCTFail("Test failed, expected to be Errors.CreateAccountError type.")
        }
    }
    
    func testGivenEmailAlreadyInUseError_WhenCreatingUser_ThenCustomEmailAlreadyInUseError() async {
        firebaseMock.success = false
        let errorCode = AuthErrorCode.emailAlreadyInUse.rawValue
        firebaseMock.testNSError = NSError(domain: "", code: errorCode, userInfo: nil)
        
        do {
            try await userAuthService.createUser(email: correctEmail,
                                                 password: correctPassword,
                                                 confirmPassword: correctConfirmPassword)
            
            XCTFail("Test failed, expected to throw but passed.")
        } catch let error as Errors.CreateAccountError {
            XCTAssertTrue(firebaseMock.createUserTriggered)
            XCTAssertEqual(error, .emailAlreadyInUse)
            XCTAssertEqual(error.localizedDescription, "Email already in use. Please choose a different one.")
        } catch {
            XCTFail("Test failed, expected to be Errors.CreateAccountError type.")
        }
    }
    
    func testGivenAnError_WhenCreatingUser_ThenCommonError() async {
        firebaseMock.success = false
        
        do {
            try await userAuthService.createUser(email: correctEmail,
                                                 password: correctPassword,
                                                 confirmPassword: correctConfirmPassword)
            
            XCTFail("Test failed, expected to throw but passed.")
        } catch let error as Errors.CommonError {
            XCTAssertTrue(firebaseMock.createUserTriggered)
            XCTAssertEqual(error, .defaultError)
            XCTAssertEqual(error.localizedDescription, "Something went wrong, please try again.")
        } catch {
            XCTFail("Test failed, expected to be Errors.CommonError type.")
        }
    }
    
    func testGivenCorrectInformations_WhenCreatingUser_ThenUserIsCreated() async {
        do {
            try await userAuthService.createUser(email: correctEmail,
                                                 password: correctPassword,
                                                 confirmPassword: correctConfirmPassword)
            
            XCTAssertTrue(firebaseMock.createUserTriggered)
            
            // If there is no throw, test succeeded.
            // However, I cant' use XCTAssertNoThrow(), because 'async' call in an autoclosure does not support concurrency.
        } catch {
            XCTFail("Test failed, did not expected to throw.")
        }
    }
}
