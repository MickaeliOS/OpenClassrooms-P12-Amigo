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
        if fieldsControl() {
            
        }
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
    }
    
    private func fieldsControl() -> Bool {
        let fields = [lastnameTextField.text,
                      firstnameTextField.text,
                      genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex),
                      descriptionTextView.text]
        
        return userService.emptyControl(fields: fields)
    }
    
    private func setupImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    private func bannerImageChangingFlow() {
        fromBanner = true
        setupImagePicker()
    }
    
    private func profilePictureChangingFlow() {
        fromBanner = false
        setupImagePicker()
    }
}

// MARK: - EXTENSIONS
extension EditProfileVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if fromBanner {
            bannerImage.image = info[.editedImage] as? UIImage
            dismiss(animated: true)
        }
    }
}
