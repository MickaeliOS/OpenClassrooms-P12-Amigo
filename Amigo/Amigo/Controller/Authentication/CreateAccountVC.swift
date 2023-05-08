//
//  CreateAccountVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 12/04/2023.
//

import UIKit
import FirebaseAuth

class CreateAccountVC: UIViewController {
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var createAccountButton: UIButton!
    
    private let userCreationService = UserCreationService()
    private var isPasswordVisible = false
    
    // MARK: - ACTIONS
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        createUserFlow()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        lastnameTextField.resignFirstResponder()
        firstnameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        setupTextFields()
        createAccountButton.layer.cornerRadius = 10
    }
    
    private func setupTextFields() {
        guard let personImage = UIImage(systemName: "person.fill"),
              let envelopeImage = UIImage(systemName: "envelope.fill"),
              let passwordLockImage = UIImage(systemName: "lock.fill") else { return }
        
        // We incorporated small icons within our TextFields to enhance the overall design aesthetics.
        lastnameTextField.addLeftSystemImage(image: personImage)
        firstnameTextField.addLeftSystemImage(image: personImage)
        emailTextField.addLeftSystemImage(image: envelopeImage)
        passwordTextField.addLeftSystemImage(image: passwordLockImage)
        confirmPasswordTextField.addLeftSystemImage(image: passwordLockImage)
        confirmPasswordTextField.addPasswordToggleImage(target: self, action: #selector(togglePasswordVisibility))
    }
    
    private func createUserFlow() {
        do {
            try userCreationService.emptyFieldsFormControl(email: emailTextField.text,
                                                               password: passwordTextField.text,
                                                               confirmPassword: confirmPasswordTextField.text,
                                                               lastname: lastnameTextField.text,
                                                               firstname: firstnameTextField.text,
                                                               gender: genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex))
            
            try userCreationService.checkingLogs(email: emailTextField.text!,
                                                 password: passwordTextField.text!,
                                                 confirmPassword: confirmPasswordTextField.text!)
            
        } catch let error as Errors.CommonError {
            errorMessageLabel.displayErrorMessage(message: error.localizedDescription)
            return
        }
        catch let error as Errors.CreateAccountError {
            errorMessageLabel.displayErrorMessage(message: error.localizedDescription)
            return
        } catch {
            presentAlert(with: Errors.CommonError.defaultError.localizedDescription)
            return
        }
        
        Task {
            do {
                let firebaseUser = try await userCreationService.createUser(email: emailTextField.text!, password: passwordTextField.text!)
                
                // Creating our User object to save it in Firestore.
                let genderRawValue = genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex)
                let gender = User.Gender(rawValue: genderRawValue ?? User.Gender.man.rawValue)
                
                let user = User(firstname: firstnameTextField.text!,
                                lastname: lastnameTextField.text!,
                                gender: gender!,
                                email: firebaseUser.email!)
                
                try await userCreationService.saveUserInDatabase(user: user)
                
                // If all the create user process went good, we can go back on the TabBar.
                performSegue(withIdentifier: Constant.SegueID.unwindToRootVC, sender: nil)
                
            } catch let error as Errors.CreateAccountError {
                errorMessageLabel.displayErrorMessage(message: error.localizedDescription)
            } catch let error as Errors.DatabaseError {
                errorMessageLabel.displayErrorMessage(message: error.localizedDescription)
            } catch let error as Errors.CommonError {
                errorMessageLabel.displayErrorMessage(message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - OBJC FUNCTIONS
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        isPasswordVisible.toggle()
        
        if isPasswordVisible {
            sender.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
        
        confirmPasswordTextField.isSecureTextEntry = !isPasswordVisible
    }
}

// MARK: - EXTENSIONS
extension CreateAccountVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        errorMessageLabel.isHidden = true
        return true
    }
}
