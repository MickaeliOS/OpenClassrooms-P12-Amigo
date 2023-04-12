//
//  CreateAccountVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 12/04/2023.
//

import UIKit
import FirebaseAuth

class CreateAccountVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    let authService = FirebaseManager()

    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        registerUser()
    }
    
    private func registerUser() {
        guard fieldsControl() else {
            //TODO: Erreur, Remplir tous les champs
            print("MKA - Erreur, Remplir tous les champs")

            return
        }
        
        authService.createUser(email: emailTextField.text!, password: passwordTextField.text!) { success, error in
            if let error = error {
                //TODO: Handle error
                print("MKA - ERROR createUser")
                print(error.localizedDescription)
                return
            }
            
            guard success else {
                //TODO: Handle le non succes
                print("MKA - NO SUCCESS createUser")

                return
            }

            guard let user = self.createUserObject() else {
                //TODO: Problème d'instanciation de l'user
                print("MKA - Problème d'instanciation de l'user")
                return
            }
            
            self.authService.saveUserInDatabase(user: user) { [weak self] success, error in
                if let error = error {
                    //TODO: Handle error
                    print("MKA - ERROR Database")

                    return
                }
                
                guard success else {
                    //TODO: Handle le non succes
                    print("MKA - NO SUCCESS Database")

                    return
                }
                print("MKA - USER SAVED")                
            }
        }
    }
    
    private func fieldsControl() -> Bool {
        if lastnameTextField.isEmpty ||
            firstnameTextField.isEmpty ||
            emailTextField.isEmpty ||
            passwordTextField.isEmpty ||
            confirmPasswordTextField.isEmpty {
            return false
        }
        return true
    }
    
    private func createUserObject() -> User? {
        guard let userID = Auth.auth().currentUser?.uid else {
            //TODO: Handle le cas ou on a pas d'UID
            return nil
        }
        
        guard let genderRawValue = genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex),
              let gender = User.Gender(rawValue: genderRawValue) else {
            //TODO: Problème d'instanciation du genre
            return nil
        }
        
        let user = User(userID: userID,
                        firstname: firstnameTextField.text!,
                        lastname: lastnameTextField.text!,
                        gender: gender,
                        email: emailTextField.text!)
        return user
    }

}
