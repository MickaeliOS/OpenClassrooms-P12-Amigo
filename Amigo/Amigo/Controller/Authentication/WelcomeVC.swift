//
//  WelcomeVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 11/04/2023.
//

import UIKit

class WelcomeVC: UIViewController {
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    private var isPasswordVisible = false
    private let userAuthService = UserAuthService()

    // MARK: - ACTIONS
    @IBAction func loginButtonTapped(_ sender: Any) {
        loginFlow()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        setupTextFields()
        loginButton.layer.cornerRadius = 10
    }
    
    private func setupTextFields() {
        guard let emailImage = UIImage(systemName: "envelope.fill"),
              let passwordLeftImage = UIImage(systemName: "lock.fill") else { return }
        
        // We incorporated small icons within our TextFields to enhance the overall design aesthetics.
        emailTextField.addLeftSystemImage(image: emailImage)
        passwordTextField.addLeftSystemImage(image: passwordLeftImage)
        passwordTextField.addPasswordToggleImage(target: self, action: #selector(togglePasswordVisibility))
    }
    
    private func loginFlow() {
        if fieldsControl() {
            errorMessageLabel.displayErrorMessage(message: Errors.CommonError.emptyFields.localizedDescription)
            return
        }
        
        Task {
            do {
                try await userAuthService.signIn(email: emailTextField.text!, password: passwordTextField.text!)
                performSegue(withIdentifier: Constant.SegueID.unwindToRootVC, sender: nil)
            } catch let error as Errors.SignInError {
                errorMessageLabel.displayErrorMessage(message: error.localizedDescription)
            } catch let error as Errors.CommonError {
                errorMessageLabel.displayErrorMessage(message: error.localizedDescription)
            }
        }
    }
    
    private func fieldsControl() -> Bool {
        return (emailTextField.isEmpty || passwordTextField.isEmpty)
    }
    
    // MARK: - OBJC FUNCTIONS
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        isPasswordVisible.toggle()
        
        if isPasswordVisible {
            sender.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }

        passwordTextField.isSecureTextEntry = !isPasswordVisible
    }
}

// MARK: - EXTENSIONS
extension WelcomeVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        errorMessageLabel.isHidden = true
        return true
    }
}
