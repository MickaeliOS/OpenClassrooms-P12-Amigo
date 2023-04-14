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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - OUTLETS & VARIABLES
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    let firebaseManager = FirebaseManager()

    // MARK: - ACTIONS
    @IBAction func loginButtonTapped(_ sender: Any) {
        //TODO: Contrôler les champs
        
        firebaseManager.signIn(email: emailTextField.text ?? "", password: passwordTextField.text ?? "") { success, error in
            if let _ = error {
                //TODO: Handle Errors
                return
            }
            
            guard success else {
                //TODO: Handle No Success
                return
            }
            
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        loginButton.layer.cornerRadius = 10
    }
    
    private func createAccount() {
        
    }
}
