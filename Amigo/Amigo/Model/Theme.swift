//
//  Theme.swift
//  Amigo
//
//  Created by Mickaël Horn on 18/04/2023.
//

import Foundation
import UIKit

enum Theme: Int {
    // MARK: - SINGLETON
    static let shared = Theme()
    private init() {
        self = .unspecified
    }
    
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
    
    func saveMode(sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "theme")
    }
    
    func changeMode(mode: UIUserInterfaceStyle) {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first(where: { $0.isKeyWindow })?
            .overrideUserInterfaceStyle = mode
    }
}
