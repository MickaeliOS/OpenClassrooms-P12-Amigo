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
    }
    
    // MARK: - OUTLETS, VARIABLES & ENUMS
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var themeSegmentedControl: UISegmentedControl!
    
    private let userAuth = UserAuth.shared
    private let userAuthService = UserAuthService()
    //private let theme = Theme.shared
    
    var currentTheme: Theme {
        return Theme(rawValue: UserDefaults.standard.integer(forKey: "theme")) ?? .unspecified
    }
    
    // MARK: - ACTIONS
    @IBAction func toggleSegmentedControl(_ sender: UISegmentedControl) {
        currentTheme.saveMode(sender: sender)
        Theme.changeMode(mode: currentTheme.interfaceStyle)
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        do {
            try userAuthService.signOut()
            presentVCFullScreen(with: "WelcomeVC")
        } catch (let error) {
            presentErrorAlert(with: error.localizedDescription)
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupSegmentedControl() {
        themeSegmentedControl.selectedSegmentIndex = currentTheme.rawValue
    }
}
