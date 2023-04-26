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
        // Retrieving images
        getProfilePicture()
        getBannerImage()
        
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
    
    private func getProfilePicture() {
        guard let user = userAuth.user else {
            presentAlert(with: "An error occured, please reconnect.")
            return
        }
        
        Task {
            let result = try await pictureService.getImage(path: user.profilePicture?.image ?? "")
            userAuth.user?.profilePicture?.data = result
            profilePictureImage.image = UIImage(data: result)
        }
    }
    
    private func getBannerImage() {
        guard let user = userAuth.user else {
            presentAlert(with: "An error occured, please reconnect.")
            return
        }
        
        Task {
            let result = try await pictureService.getImage(path: user.banner?.image ?? "")
            userAuth.user?.banner?.data = result
            bannerImage.image = UIImage(data: result)
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
