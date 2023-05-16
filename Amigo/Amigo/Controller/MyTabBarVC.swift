//
//  MyTabBarVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 16/05/2023.
//

import UIKit

class MyTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

extension MyTabBarVC: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let barViewControllers = viewControllers
        
        guard let tripNavigationController = barViewControllers![0] as? UINavigationController,
              let tripVC = tripNavigationController.topViewController as? TripVC else { return }
        
        guard let settingsVC = barViewControllers![1] as? SettingsVC else { return }
        
        if item.title == "Settings" {
            //print("MKA - SETTINGS PRESSED")
            settingsVC.user = tripVC.user
        }
        
        if item.title == "My Trips" {
            //print("MKA - TRIPS PRESSED")
            tripVC.user = settingsVC.user
        }
    }
}
