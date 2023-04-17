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
        
        switch theme {
        case .unspecified:
            themeSegmentedControl.selectedSegmentIndex = 0
        case .light:
            themeSegmentedControl.selectedSegmentIndex = 1
        case .dark:
            themeSegmentedControl.selectedSegmentIndex = 2
        }
        
        changeMode(mode: theme.interfaceStyle)
    }
    
    // MARK: - OUTLETS, VARIABLES & ENUMS
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var themeSegmentedControl: UISegmentedControl!
    let userService = UserService.shared
    
    var theme: Theme {
        return Theme(rawValue: UserDefaults.standard.integer(forKey: "theme")) ?? .unspecified
    }
    
    enum Theme: Int {
        case unspecified
        case light
        case dark
        
        var interfaceStyle: UIUserInterfaceStyle {
            switch self {
            case .unspecified:
                return .unspecified
            case .light:
                return .light
            case .dark:
                return .dark
            }
        }
    }
    
    // MARK: - ACTIONS
    @IBAction func toggleSegmentedControl(_ sender: UISegmentedControl) {
        saveMode(sender: sender)
        changeMode(mode: theme.interfaceStyle)
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
    private func saveMode(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "theme")
        case 1:
            UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "theme")
        case 2:
            UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "theme")
        default:
            UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "theme")
        }
    }
    
    private func changeMode(mode: UIUserInterfaceStyle) {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first(where: { $0.isKeyWindow })?
            .overrideUserInterfaceStyle = mode
    }
}
