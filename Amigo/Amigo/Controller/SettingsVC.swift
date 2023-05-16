//
//  SettingsVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 17/04/2023.
//

import UIKit
import FirebaseAuth

class SettingsVC: UIViewController {
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        setupInterface()
        setupVoiceOver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPersonalInformations()
    }
    
    // MARK: - OUTLETS, VARIABLES & ENUMS
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var themeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var saveProfileButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    var user: User?
    private let currentUser = Auth.auth().currentUser
    private let userAuthService = UserAuthService()
    private let userUpdatingService = UserUpdatingService()
    private let userCreationService = UserCreationService()

    var currentTheme: Theme {
        return Theme(rawValue: UserDefaults.standard.integer(forKey: "theme")) ?? .unspecified
    }
    
    // MARK: - ACTIONS
    @IBAction func toggleSegmentedControl(_ sender: UISegmentedControl) {
        currentTheme.saveMode(sender: sender)
        Theme.changeMode(mode: currentTheme.interfaceStyle)
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        presentDestructiveAlert(with: "Are you sure you want to Log Out ?") {
            self.signOut()
        }
    }
    
    @IBAction func saveProfileButtonTapped(_ sender: Any) {
        saveProfileFlow()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        lastnameTextField.resignFirstResponder()
        firstnameTextField.resignFirstResponder()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func saveProfileFlow() {
        guard let currentUser = currentUser else {
            presentErrorAlert(with: Errors.DatabaseError.noUser.localizedDescription)
            return
        }
        
        if lastnameTextField.isEmpty || firstnameTextField.isEmpty {
            errorMessageLabel.displayErrorMessage(message: "All fields must be filled.")
            return
        }
        
        toggleActivityIndicator(shown: true)
        
        if user == nil {
            createUser(currentUser: currentUser, userID: currentUser.uid)
        } else {
            updateUser(userID: currentUser.uid)
        }
    }
    
    private func createUser(currentUser: FirebaseAuth.User, userID: String) {
        Task {
            do {
                // First, I get the gender.
                let selectedIndex = genderSegmentedControl.selectedSegmentIndex
                let gender: User.Gender = selectedIndex == 0 ? .woman : .man
                
                // Then, I create the User.
                let user = User(firstname: firstnameTextField.text!,
                                lastname: lastnameTextField.text!, gender: gender,
                                email: currentUser.email!)
                
                // We are prepared to persistently save the user's data, both remotely and locally.
                try await userCreationService.saveUserInDatabase(user: user, userID: userID)
                self.user = user
                
                // Finally, we conclude the process by executing a set of essential functions.
                toggleActivityIndicator(shown: false)
                refreshInterface()
                setupPersonalInformations()
                //passDataToTripVC()
                presentInformationAlert(with: "Your profile has been saved.")
                
            } catch let error as Errors.DatabaseError {
                presentErrorAlert(with: error.localizedDescription)
            }
        }
    }
    
    private func updateUser(userID: String) {
        Task {
            do {
                // First, we get the value from genderSegmentedControl
                let genderRawValue = genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex) ?? User.Gender.woman.rawValue
                
                // Then, we provide the fields to be updated.
                let fields = [Constant.FirestoreTables.User.lastname: lastnameTextField.text!,
                              Constant.FirestoreTables.User.firstname: firstnameTextField.text!,
                              Constant.FirestoreTables.User.gender: genderRawValue]
                
                // Finally, we can save our user locally and remotely.
                try await userUpdatingService.updateUser(fields: fields, userID: userID)
                
                user?.lastname = lastnameTextField.text!
                user?.firstname = firstnameTextField.text!
                user?.gender = User.Gender(rawValue: genderRawValue)!
                
                // We execute some essentials functions to finish the process.
                toggleActivityIndicator(shown: false)
                refreshInterface()
                setupPersonalInformations()
                //passDataToTripVC()
                presentInformationAlert(with: "Your profile has been saved.")
            } catch let error as Errors.DatabaseError {
                presentErrorAlert(with: error.localizedDescription)
            }
            
            toggleActivityIndicator(shown: false)
        }
    }
    
    private func setupSegmentedControl() {
        themeSegmentedControl.selectedSegmentIndex = currentTheme.rawValue
    }
    
    private func setupInterface() {
        saveProfileButton.layer.cornerRadius = 10
    }
    
    private func refreshInterface() {
        lastnameTextField.text = ""
        firstnameTextField.text = ""
        lastnameTextField.resignFirstResponder()
        firstnameTextField.resignFirstResponder()
    }
    
    private func setupPersonalInformations() {
        guard let name = user?.lastname, let firstname = user?.firstname else {
            return
        }
        
        lastnameTextField.placeholder = name
        firstnameTextField.placeholder = firstname
        genderSegmentedControl.selectedSegmentIndex = User.Gender.index(of: user?.gender ?? .woman)
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        // If shown is true, then the refresh button is hidden and we display the Activity Indicator
        // If not, we hide the Activity Indicator and show the refresh button
        saveProfileButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    
    private func signOut() {
        do {
            try userAuthService.signOut()
            presentVCFullScreen(with: "WelcomeVC")
        } catch let error as Errors.SignOutError {
            presentErrorAlert(with: error.localizedDescription)
        } catch {
            presentErrorAlert(with: error.localizedDescription)
        }
    }
    
    private func setupVoiceOver() {
        // Labels
        themeSegmentedControl.accessibilityLabel = "The choices for the theme."
        genderSegmentedControl.accessibilityLabel = "The choices for the gender."
        
        // Values
        themeSegmentedControl.accessibilityValue = "Device theme, Light, Dark."
        genderSegmentedControl.accessibilityValue = "Woman, man."
        
        // Hints
        logOutButton.accessibilityHint = "Press to log out."
        lastnameTextField.accessibilityHint = "Write your lastname"
        firstnameTextField.accessibilityHint = "Write your firstname"
        themeSegmentedControl.accessibilityHint = "Select the new theme."
        genderSegmentedControl.accessibilityHint = "Select your gender"
        saveProfileButton.accessibilityHint = "Press to save your profile."
    }
    
    /*private func passDataToTripVC() {
        let barViewControllers = tabBarController?.viewControllers
        guard let TripVC = barViewControllers![0] as? TripVC else { return }
        TripVC.user = user
    }*/
}

// MARK: - EXTENSIONS
extension SettingsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        errorMessageLabel.isHidden = true
    }
}
