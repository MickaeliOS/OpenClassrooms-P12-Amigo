//
//  AddTripVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 14/04/2023.
//

import UIKit
import FirebaseAuth

class AddTripVC: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelToDLete: UILabel!
    var userService = UserService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startLoginFlow()
    }
    
    private func startLoginFlow() {
        if userService.currentlyLoggedIn {
            activityIndicator.isHidden = false
            FirebaseManager().fetchUser { success, error in
                if let _ = error {
                    //TODO: Handle Error
                }
                
                guard success else {
                    //TODO: Handle No Success
                    return
                }
                
                self.setupInterface()
                return
            }
            return
        }
        self.presentVCFullScreen(with: "WelcomeVC")
    }
    
    /*private func fetchUser() {
        UserService.shared.loginFlow { result in
            guard result else {
                self.presentVCFullScreen(with: "WelcomeVC")
                return
            }
            
            self.setupInterface()
        }
    }*/
    
    private func setupInterface() {
        self.activityIndicator.isHidden = true
        self.labelToDLete.text = UserService.shared.user?.firstname
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
