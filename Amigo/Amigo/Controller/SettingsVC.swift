//
//  SettingsVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 17/04/2023.
//

import UIKit

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
    
    private let userAuth = UserAuth.shared
    private let userAuthService = UserAuthService()
    private let userUpdatingService = UserUpdatingService()

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
        if lastnameTextField.isEmpty || firstnameTextField.isEmpty {
            errorMessageLabel.displayErrorMessage(message: "All fields must be filled.")
            return
        }
        
        toggleActivityIndicator(shown: true)
        
        Task {
            do {
                // First, we get the value from genderSegmentedControl
                let genderRawValue = genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex)
                
                // Then, we provide the fields to be updated.
                let fields = [Constant.FirestoreTables.User.lastname: lastnameTextField.text!,
                              Constant.FirestoreTables.User.firstname: firstnameTextField.text!,
                              Constant.FirestoreTables.User.gender: genderRawValue ?? User.Gender.woman.rawValue]
                
                // Finally, we can save our user locally and remotely.
                try await userUpdatingService.updateUser(fields: fields)
                userAuth.user?.lastname = lastnameTextField.text!
                userAuth.user?.firstname = firstnameTextField.text!
                userAuth.user?.gender = User.Gender(rawValue: genderRawValue ?? User.Gender.woman.rawValue)
                
                refreshInterface()
                setupPersonalInformations()
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
        guard let name = userAuth.user?.lastname, let firstname = userAuth.user?.firstname else {
            return
        }
        
        lastnameTextField.placeholder = name
        firstnameTextField.placeholder = firstname
        genderSegmentedControl.selectedSegmentIndex = User.Gender.index(of: userAuth.user?.gender ?? .woman)
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
        themeSegmentedControl.accessibilityLabel = "The choices for the theme."
        genderSegmentedControl.accessibilityLabel = "The choices for the gender."
        
        themeSegmentedControl.accessibilityValue = "Device theme, Light, Dark."
        genderSegmentedControl.accessibilityValue = "Woman, man."
        
        logOutButton.accessibilityHint = "Press to log out."
        lastnameTextField.accessibilityHint = "Write your lastname"
        firstnameTextField.accessibilityHint = "Write your firstname"
        themeSegmentedControl.accessibilityHint = "Select the new theme."
        genderSegmentedControl.accessibilityHint = "Select your gender"
        saveProfileButton.accessibilityHint = "Press to save your profile."
    }
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
