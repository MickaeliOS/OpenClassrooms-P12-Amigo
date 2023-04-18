//
//  SettingsViewController.swift
//  Amigo
//
//  Created by Mickaël Horn on 17/04/2023.
//

import UIKit

class SettingsViewController: UIViewController {
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
    }
    
    // MARK: - OUTLETS, VARIABLES & ENUMS
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var themeSegmentedControl: UISegmentedControl!
    let userService = UserService.shared
    let theme = Theme.shared
    
    var currentTheme: Theme {
        return Theme(rawValue: UserDefaults.standard.integer(forKey: "theme")) ?? .unspecified
    }
    
    // MARK: - ACTIONS
    @IBAction func toggleSegmentedControl(_ sender: UISegmentedControl) {
        theme.saveMode(sender: sender)
        theme.changeMode(mode: currentTheme.interfaceStyle)
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        do {
            try userService.signOut()
            presentVCFullScreen(with: "WelcomeVC")
        } catch (let error) {
            presentAlert(with: error.localizedDescription)
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupSegmentedControl() {
        themeSegmentedControl.selectedSegmentIndex = currentTheme.rawValue
    }
}
