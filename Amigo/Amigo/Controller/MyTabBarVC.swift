//
//  MyTabBarVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 16/05/2023.
//

import UIKit

class MyTabBarVC: UITabBarController {
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    // MARK: - PROPERTIES
    // This is the centralized storage for the User object, enabling seamless data sharing among the various view controllers as I navigate between tabs.
    var user: User?
}

// MARK: - EXTENSIONS
extension MyTabBarVC: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        // To ensure that TripVC always has the most up-to-date version of the User object, I am implementing a TableView reload here.
        // This ensures that any modifications made to the User object in SettingsVC are reflected immediately in TripVC.
        if tabBar.selectedItem?.title == "My Trips" {
            if let tripNavigationController = viewControllers![0] as? UINavigationController,
               let tripVC = tripNavigationController.topViewController as? TripVC  {
                tripVC.tripTableView.reloadData()
            }
        }
    }
}
