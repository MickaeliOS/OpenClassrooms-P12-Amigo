//
//  ProfileVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 12/04/2023.
//

import UIKit

class ProfileVC: UIViewController {
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupInterface()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let userAuth = UserAuth.shared
    let pictureService = PictureService()
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        profilePictureImage.makeRounded()
        setupUserInfos()
    }
    
    private func setupUserInfos() {
        // Setup images
        setupProfilePicture()
        setupBannerImage()
        
        // Retrieving texts
        firstnameLabel.text = userAuth.user?.firstname
        lastnameLabel.text = userAuth.user?.lastname
        genderLabel.text = userAuth.user?.gender.rawValue
        
        if userAuth.user?.description == nil || userAuth.user?.description == "" {
            descriptionLabel.text = "No description."
        } else {
            descriptionLabel.text = userAuth.user?.description
        }
    }
    
    private func setupProfilePicture() {
        if let profilePictureData = userAuth.user?.profilePicture?.data {
            profilePictureImage.image = UIImage(data: profilePictureData)
        }
    }
    
    private func setupBannerImage() {
        if let bannerPictureData = userAuth.user?.banner?.data {
            bannerImage.image = UIImage(data: bannerPictureData)
        }
    }
}

// MARK: - EXTENSIONS & PROTOCOL
extension ProfileVC: EditProfileVCDelegate {
    func editProfileVCDidDismiss() {
        setupInterface()
    }
}

extension ProfileVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editProfileVC = segue.destination as? EditProfileVC {
            editProfileVC.delegate = self
        }
    }
}
