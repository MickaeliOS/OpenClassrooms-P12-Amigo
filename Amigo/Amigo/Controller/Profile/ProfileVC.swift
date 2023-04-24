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
    
    let userService = UserService.shared
    
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
        firstnameLabel.text = userService.user?.firstname
        lastnameLabel.text = userService.user?.lastname
        genderLabel.text = userService.user?.gender.rawValue
        
        if userService.user?.description == nil || userService.user?.description == "" {
            descriptionLabel.text = "No description."
        }
    }
    
    private func getProfilePicture() {
        userService.getImage(path: userService.user?.profilePicture?.image) { [weak self] data in
            guard let data = data else { return }
            
            self?.userService.user?.profilePicture?.data = data
            self?.profilePictureImage.image = UIImage(data: data)
        }
    }
    
    private func getBannerImage() {
        userService.getImage(path: userService.user?.banner?.image) { [weak self] data in
            guard let data = data else { return }
            
            self?.userService.user?.banner?.data = data
            self?.bannerImage.image = UIImage(data: data)
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
