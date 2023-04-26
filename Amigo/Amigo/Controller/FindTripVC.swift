//
//  FindTripVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 14/04/2023.
//

import UIKit
import FirebaseAuth

class FindTripVC: UIViewController {
    
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
    
    private var userAuth = UserAuth.shared
    private let userFetchingService = UserFetchingService()
    
    // MARK: - ACTIONS
    @IBAction func unwindToRootVC(segue: UIStoryboardSegue) {}
    
    // MARK: - PRIVATE FUNCTIONS
    private func startLoginFlow() {
        guard userAuth.currentlyLoggedIn else {
            presentVCFullScreen(with: "WelcomeVC")
            return
        }
        
        activityIndicator.isHidden = false

        Task {
            do {
                try await userFetchingService.fetchUser()
                setupInterface()
                print("MKA - FIN TRY")
            } catch {
                presentAlert(with: error.localizedDescription)
                presentVCFullScreen(with: "WelcomeVC") // TODO: Ne fonctionne pas, seul l'alerte marche. Si pas d'alerte, ça marche.
            }
        }
        
        print("MKA - FIN LOGIN FLOW")
    }
    
    private func setupInterface() {
        self.activityIndicator.isHidden = true
    }
}
