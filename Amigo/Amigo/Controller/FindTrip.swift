//
//  FindTrip.swift
//  Amigo
//
//  Created by Mickaël Horn on 14/04/2023.
//

import UIKit
import FirebaseAuth

class FindTrip: UIViewController {
    
    // MARK: - VIEW LIFE CYCLE
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startLoginFlow()
    }

    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var userService = UserService.shared
    
    // MARK: - ACTIONS
    @IBAction func unwindToRootVC(segue: UIStoryboardSegue) {}
    
    // MARK: - PRIVATE FUNCTIONS
    private func startLoginFlow() {
        if userService.currentlyLoggedIn {
            activityIndicator.isHidden = false
            
            userService.fetchUser { [weak self] error in
                if let error = error {
                    self?.presentAlert(with: error.localizedDescription)
                    self?.presentVCFullScreen(with: "WelcomeVC") // TODO: Ne fonctionne pas, seul l'alerte marche. Si pas d'alerte, ça marche.
                    return
                }
                
                self?.setupInterface()
                return
            }
            return
        } else {
            self.presentVCFullScreen(with: "WelcomeVC")
        }
    }
    
    private func setupInterface() {
        self.activityIndicator.isHidden = true
    }
}
