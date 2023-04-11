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
    
    // MARK: - OUTLETS & VARIABLES
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    // MARK: - ACTIONS
    @IBAction func loginButtonTapped(_ sender: Any) {
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

