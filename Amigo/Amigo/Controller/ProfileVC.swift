//
//  ProfileVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 12/04/2023.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let userService = UserService.shared
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        profilePictureImage.makeRounded()
    }
}
