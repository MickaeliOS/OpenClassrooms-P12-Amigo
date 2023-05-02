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
        registerUser()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        lastnameTextField.resignFirstResponder()
        firstnameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func registerUser() {
        do {
            try userCreationService.creationAccountFormControl(email: emailTextField.text,
                                                               password: passwordTextField.text,
                                                               confirmPassword: confirmPasswordTextField.text,
                                                               lastname: lastnameTextField.text,
                                                               firstname: firstnameTextField.text,
                                                               gender: genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex))
        } catch let error as UserError.CreateAccountError {
            errorMessageLabel.displayErrorMessage(message: error.localizedDescription)
            return
        } catch {
            presentAlert(with: UserError.CommonError.defaultError.localizedDescription)
            return
        }
        
        Task {
            do {
                let firebaseUser = try await userCreationService.createUser(email: emailTextField.text!, password: passwordTextField.text!)
                guard let user = createUserObject(authUser: firebaseUser) else { return }
                try await userCreationService.saveUserInDatabase(user: user)
                
                // If all the create user process went good, we can go back on the TabBar.
                //TODO: Comme tu as déplacé startLoginFlow() de FindTripVC dans VDL, il n'est plus redéclenché quand tu retourne là abs
                performSegue(withIdentifier: "unwindToRootVC", sender: nil)
                
            } catch let error as UserError.CreateAccountError {
                errorMessageLabel.displayErrorMessage(message: error.localizedDescription)
            } catch {
                presentAlert(with: UserError.CommonError.defaultError.localizedDescription)
            }
        }
    }
    
    private func createUserObject(authUser: FirebaseAuth.User) -> User? {
        guard let genderRawValue = genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex),
              let gender = User.Gender(rawValue: genderRawValue) else {
            return nil
        }
        
        let user = User(userID: authUser.uid,
                        firstname: firstnameTextField.text!,
                        lastname: lastnameTextField.text!,
                        gender: gender,
                        email: authUser.email!)
        return user
    }
    
    private func setupInterface() {
        setupTextFields()
        createAccountButton.layer.cornerRadius = 10
    }
    
    private func setupTextFields() {
        guard let personImage = UIImage(systemName: "person.fill"),
              let envelopeImage = UIImage(systemName: "envelope.fill"),
              let passwordLockImage = UIImage(systemName: "lock.fill") else { return }
        
        lastnameTextField.addLeftSystemImage(image: personImage)
        firstnameTextField.addLeftSystemImage(image: personImage)
        emailTextField.addLeftSystemImage(image: envelopeImage)
        passwordTextField.addLeftSystemImage(image: passwordLockImage)
        confirmPasswordTextField.addLeftSystemImage(image: passwordLockImage)
        confirmPasswordTextField.addPasswordToggleImage(target: self, action: #selector(togglePasswordVisibility))
    }
    
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

extension CreateAccountVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        errorMessageLabel.isHidden = true
        return true
    }
}
