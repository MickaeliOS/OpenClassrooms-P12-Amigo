//
//  AddTripVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 14/04/2023.
//

import UIKit
import FirebaseAuth

class AddTripVC: UIViewController {
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startLoginFlow()
    }

    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelToDLete: UILabel!
    var userService = UserService.shared
    
    // MARK: - PRIVATE FUNCTIONS
    private func startLoginFlow() {
        if userService.currentlyLoggedIn {
            activityIndicator.isHidden = false
            
            userService.fetchUser { [weak self] error in
                if let error = error {
                    self?.presentAlert(with: error.localizedDescription)
                    return
                }
                
                self?.setupInterface()
                return
            }
            return
        }
        self.presentVCFullScreen(with: "WelcomeVC")
    }
    
    private func setupInterface() {
        self.activityIndicator.isHidden = true
        self.labelToDLete.text = UserService.shared.user?.firstname
    }
}
