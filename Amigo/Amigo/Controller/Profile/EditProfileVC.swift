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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.editProfileVCDidDismiss()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveProfileButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    let pictureService = PictureService()
    let userUpdatingService = UserUpdatingService()
    let userAuth = UserAuth.shared
    var bannerPath: String?
    var profilePicturePath: String?
    var fromBanner = false
    var bannerChanged = false
    var profilePictureChanged = false
    let descriptionPlaceHolder = "Enter your description."
    weak var delegate: EditProfileVCDelegate?
    
    // MARK: - ACTIONS
    @IBAction func dismissKeyboard(_ sender: Any) {
        lastnameTextField.resignFirstResponder()
        firstnameTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
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
        setupPictures()
        
        saveProfileButton.layer.cornerRadius = 10
        lastnameTextField.text = userAuth.user?.lastname
        firstnameTextField.text = userAuth.user?.firstname
        
        switch userAuth.user?.gender {
        case .woman:
            genderSegmentedControl.selectedSegmentIndex = 0
        case .man:
            genderSegmentedControl.selectedSegmentIndex = 1
        case .none:
            genderSegmentedControl.selectedSegmentIndex = 0
        }
        
        if userAuth.user?.description != nil && userAuth.user?.description != "" {
            descriptionTextView.text = userAuth.user?.description
        } else {
            // The text view's place holder
            descriptionTextView.text = descriptionPlaceHolder
            descriptionTextView.textColor = UIColor.placeholderText
        }
    }
    
    private func setupPictures() {
        if let bannerImageData = userAuth.user?.banner?.data {
            bannerImage.image = UIImage(data: bannerImageData)
        }
        
        if let profilePictureImageData = userAuth.user?.profilePicture?.data {
            profilePictureImage.image = UIImage(data: profilePictureImageData)
        }

        bannerPath = userAuth.user?.banner?.image
        profilePicturePath = userAuth.user?.profilePicture?.image
        profilePictureImage.makeRounded()
    }
    
    private func fieldsControl() -> Bool {
        // We make sure the mandatory fields are filled.
        guard !lastnameTextField.isEmpty, !firstnameTextField.isEmpty else {
            return false
        }
        
        guard let _ = genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex) else {
            return false
        }
        
        return true
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
        toggleActivityIndicator(shown: true)

        guard let currentUser = userAuth.user else {
            presentAlert(with: "An error occured, please reconnect.")
            toggleActivityIndicator(shown: false)
            return
        }
        
        // First step -> we make sure the mandatory fields are filled.
        guard fieldsControl() else {
            errorMessageLabel.displayErrorMessage(message: "These fields must be filled : \n - Lastname \n - Firstname")
            toggleActivityIndicator(shown: false)
            return
        }
        
        // Second step -> We instanciate the changedUser with potential new informations.
        let changedUser = getChangedUser(currentUser: currentUser)
        
        // Third step -> Let's get the potential modified properties.
        var modifiedProperties = userUpdatingService.changedProperties(from: currentUser, to: changedUser)
        
        if modifiedProperties.isEmpty, !bannerChanged, !profilePictureChanged {
            // Nothing to change, we can head back to ProfileVC.
            dismiss(animated: true)
            return
        }
        
        Task {
            do {
                if let bannerData = changedUser.banner?.data, bannerChanged {
                    let bannerPath = try await pictureService.uploadPicture(picture: bannerData, type: Constant.FirestoreTables.User.banner)
                    
                    // Fourth step -> Once we have the path, we add it in our property for later.
                    self.bannerPath = bannerPath
                }
                
                if let profilePictureData = changedUser.profilePicture?.data, profilePictureChanged {
                    let profilePicturePath = try await pictureService.uploadPicture(picture: profilePictureData, type: Constant.FirestoreTables.User.profilePicture)
                    
                    // Fourth step -> Once we have the path, we add it in our property for later.
                    self.profilePicturePath = profilePicturePath
                }
                
                // Last step -> Update the user, plus the singleton
                try await userUpdatingService.updateUser(fields: modifiedProperties)
                userAuth.user = changedUser
                
                if let bannerPath = bannerPath {
                    userAuth.user?.banner?.image = bannerPath
                }
                
                if let profilePicturePath = profilePicturePath {
                    userAuth.user?.profilePicture?.image = profilePicturePath
                }
                
                dismiss(animated: true)
            } catch {
                presentAlert(with: error.localizedDescription)
            }
        }
    }
    
    private func getChangedUser(currentUser: User) -> User {
        let genderRawValue = genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex)!
        let gender = User.Gender(rawValue: genderRawValue)!
        let bannerImageData = bannerImage.image?.pngData()
        let profilePictureImageData = profilePictureImage.image?.pngData()

        let changedUser = User(userID: currentUser.userID,
                               firstname: firstnameTextField.text!,
                               lastname: lastnameTextField.text!,
                               gender: gender,
                               email: currentUser.email,
                               description: descriptionTextView.text == descriptionPlaceHolder ? nil : descriptionTextView.text,
                               profilePicture: ImageInfos(data: profilePictureImageData),
                               banner: ImageInfos(data: bannerImageData))
        return changedUser
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        // If shown is true, then the button is hidden and we display the Activity Indicator
        // If not, we hide the Activity Indicator and show the button
        saveProfileButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
}

// MARK: - EXTENSIONS & PROTOCOL
extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if fromBanner {
            bannerImage.image = info[.editedImage] as? UIImage
            bannerChanged = true
        } else {
            profilePictureImage.image = info[.editedImage] as? UIImage
            profilePictureChanged = true
        }
        dismiss(animated: true)
    }
}

extension EditProfileVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        errorMessageLabel.isHidden = true
        return true
    }
}

extension EditProfileVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText {
            textView.text = nil
            textView.textColor = UIColor.label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = descriptionPlaceHolder
            textView.textColor = UIColor.placeholderText
        }
    }
}

protocol EditProfileVCDelegate: AnyObject {
    func editProfileVCDidDismiss()
}
