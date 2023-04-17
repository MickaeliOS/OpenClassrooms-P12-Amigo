//
//  WelcomeVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 11/04/2023.
//

import UIKit
import FirebaseAuth

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
    let userService = UserService.shared

    // MARK: - ACTIONS
    @IBAction func loginButtonTapped(_ sender: Any) {
        if fieldsControl() {
            userService.signIn(email: emailTextField.text!, password: passwordTextField.text!) { [weak self] error in
                if let error = error {
                    self?.errorMessageLabel.isHidden = false
                    self?.errorMessageLabel.text = error.localizedDescription
                    return
                }
                
                self?.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        loginButton.layer.cornerRadius = 10
        setupTextFields()
    }
    
    private func setupTextFields() {
        guard let emailImage = UIImage(systemName: "envelope.fill"),
              let passwordLeftImage = UIImage(systemName: "lock.fill"),
              let passwordRightImage = UIImage(systemName: "eye.fill") else { return }
        
        emailTextField.addLeftSystemImage(image: emailImage,
                                          paddingLeft: 15,
                                          paddingRight: 0,
                                          size: 25)
        passwordTextField.addLeftSystemImage(image: passwordLeftImage,
                                              paddingLeft: 15,
                                              paddingRight: 0,
                                              size: 25)
        passwordTextField.addRightSystemImage(image: passwordRightImage,
                                              paddingLeft: 0,
                                              paddingRight: 15,
                                              size: 25)
    }
    
    private func fieldsControl() -> Bool {
        if emailTextField.isEmpty || passwordTextField.isEmpty {
            errorMessageLabel.isHidden = false
            errorMessageLabel.text = "All fields must be filled."
            return false
        }
        return true
    }
}

extension WelcomeVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        errorMessageLabel.isHidden = true
        return true
    }
}
