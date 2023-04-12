//
//  CustomTabBarController.swift
//  Amigo
//
//  Created by Mickaël Horn on 12/04/2023.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    var user: User?
    var firebaseManager = FirebaseManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
    }
    
    private func fetchUser() {
        FirebaseManager().fetchUser { [weak self] user in
            guard let user = user else {
                print("MKA - PAS D'USER")
                return
            }
            
            print("MKA - User logged in")
            self?.user = user
            self?.transmitUser()
        }
    }

    private func transmitUser() {
        self.delegate = self
        
        guard let viewControllers = viewControllers else { return }
        
        for viewController in viewControllers {
            if let navigationController = viewController as? UINavigationController {
                // We give all the VC the user object, fetched from Firebase.
                if let profileVC = navigationController.viewControllers.first as? ProfileVC {
                    profileVC.user = user
                }
            }
        }
    }
}
