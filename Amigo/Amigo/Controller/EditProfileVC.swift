//
//  EditProfileVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 19/04/2023.
//

import UIKit

class EditProfileVC: UIViewController {
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveProfileButton: UIButton!
    let userService = UserService.shared
    var fromBanner = false
    
    // MARK: - ACTIONS
    @IBAction func saveProfileButtonTapped(_ sender: Any) {
        saveUserProfile()
    }
    
    @IBAction func bannerImageTapped(_ sender: UITapGestureRecognizer) {
        bannerImageChangingFlow()
    }
    
    @IBAction func profilePictureTapped(_ sender: UITapGestureRecognizer) {
        profilePictureChangingFlow()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        profilePictureImage.makeRounded()
        saveProfileButton.layer.cornerRadius = 10
    }
    
    private func fieldsControl() -> Bool {
        // We make sure the mandatory fields are filled.
        let fields = [lastnameTextField.text,
                      firstnameTextField.text,
                      genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex)]
        
        return userService.emptyControl(fields: fields)
    }
    
    private func bannerImageChangingFlow() {
        fromBanner = true
        setupImagePicker()
    }
    
    private func profilePictureChangingFlow() {
        fromBanner = false
        setupImagePicker()
    }
    
    private func setupImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    private func saveUserProfile() {
        if fieldsControl() {
            let genderRawValue = genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex)!
            let gender = User.Gender(rawValue: genderRawValue)!
            
            userService.user?.firstname = firstnameTextField.text!
            userService.user?.lastname = lastnameTextField.text!
            userService.user?.gender = gender
            userService.user?.description = descriptionTextView.text!

            let bannerImageData = bannerImage.image?.pngData()
            userService.uploadPicture(picture: bannerImageData, type: "banner") { [weak self] success in
                if success {
                    
                    let profilePictureImageData = self?.profilePictureImage.image?.pngData()
                    self?.userService.uploadPicture(picture: profilePictureImageData, type: "profilePicture") { [weak self] success in
                        if success {
                            
                            //userService.
                        } else {
                            //TODO: Gérer l'erreur
                        }
                    }
                } else {
                    //TODO: Gérer l'erreur
                }
            }
        }
    }
}

// MARK: - EXTENSIONS
extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if fromBanner {
            bannerImage.image = info[.editedImage] as? UIImage
        } else {
            profilePictureImage.image = info[.editedImage] as? UIImage
        }
        dismiss(animated: true)
    }
}
