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
    var changedUser: User?
    
    // MARK: - ACTIONS
    @IBAction func saveProfileButtonTapped(_ sender: Any) {
        saveUserProfile()
        
        /*let pngData = UIImage(data: (userService.user?.banner?.data)!)?.pngData()
        print("MKA - equalData : \(pngData == bannerImage.image?.pngData())")*/
    }
    
    @IBAction func bannerImageTapped(_ sender: UITapGestureRecognizer) {
        bannerImageChangingFlow()
    }
    
    @IBAction func profilePictureTapped(_ sender: UITapGestureRecognizer) {
        profilePictureChangingFlow()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        /*if let bannerImageData = userService.user?.banner?.data {
            bannerImage.image = UIImage(data: bannerImageData)
        }
        
        if let profilePictureImageData = userService.user?.profilePicture?.data {
            profilePictureImage.image = UIImage(data: profilePictureImageData)
        }*/
        
        bannerImage.image = UIImage(systemName: "photo")
        profilePictureImage.image = UIImage(systemName: "photo")

        profilePictureImage.makeRounded()
        saveProfileButton.layer.cornerRadius = 10
        lastnameTextField.text = userService.user?.lastname
        firstnameTextField.text = userService.user?.firstname
        
        switch userService.user?.gender {
        case .woman:
            genderSegmentedControl.selectedSegmentIndex = 0
        case .man:
            genderSegmentedControl.selectedSegmentIndex = 1
        case .none:
            genderSegmentedControl.selectedSegmentIndex = 0
        }
        
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
        guard let currentUser = userService.user else {
            //TODO: demande à se relog
            return
        }
        
        // First step -> we make sure the mandatory fields are filled.
        guard fieldsControl() else {
            //TODO: Fields must not be empty
            return
        }
        
        // Second step -> we instanciate the changedUser with potential new informations.
        let genderRawValue = genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex)!
        let gender = User.Gender(rawValue: genderRawValue)!
        let bannerImageData = bannerImage.image?.pngData()
        let profilePictureImageData = profilePictureImage.image?.pngData()

        
        changedUser = User(userID: currentUser.userID,
                               firstname: firstnameTextField.text!,
                               lastname: lastnameTextField.text!,
                               gender: gender,
                               email: currentUser.email,
                               description: descriptionTextView.text,
                               profilePicture: ImageInfos(data: bannerImageData),
                               banner: ImageInfos(data: profilePictureImageData))
        
        // Third step -> Let's get the potential modified properties
        guard var modifiedProperties = userService.getModifiedProperties(from: changedUser!) else {
            //TODO: Rien à update
            return
        }
        
        // Fourth step -> We need to upload the images first, because once they are uploaded in Storage, we need the URL in order to save it in Firestore.
        if modifiedProperties[Constant.FirestoreTables.User.banner] != nil && modifiedProperties[Constant.FirestoreTables.User.profilePicture] != nil {
            
            userService.uploadPicture(picture: bannerImageData, type: Constant.FirestoreTables.User.banner) { [weak self] imagePath in
                guard let bannerPath = imagePath else {
                    //TODO: Gérer l'erreur
                    return
                }
                
                self?.userService.uploadPicture(picture: profilePictureImageData, type: Constant.FirestoreTables.User.profilePicture) { [weak self] imagePath in
                    guard let profilePicturePath = imagePath else {
                        //TODO: Gérer l'erreur
                        return
                    }
                    
                    // Fifth step -> Once we have the paths, we add them in the modifiedProperties dictionnary.
                    modifiedProperties[Constant.FirestoreTables.User.banner] = bannerPath
                    modifiedProperties[Constant.FirestoreTables.User.profilePicture] = profilePicturePath

                    // Last step -> We can save the user.
                    self?.userService.updateUser(fields: modifiedProperties) { error in
                        if let error = error {
                            //TODO: Gérer l'erreur
                            return
                        }
                        self?.userService.user = self?.changedUser
                        return
                    }
                }
            }
        } else {
            // Fourth step -> We need to upload the images first, because once they are uploaded in Storage, we need the URL in order to save it in Firestore.
            if modifiedProperties[Constant.FirestoreTables.User.banner] != nil {
                userService.uploadPicture(picture: bannerImageData, type: Constant.FirestoreTables.User.banner) { [weak self] imagePath in
                    guard let bannerPath = imagePath else {
                        //TODO: Gérer l'erreur
                        return
                    }
                    // Fifth step -> Once we have the path, we add it in the modifiedProperties dictionnary.
                    modifiedProperties[Constant.FirestoreTables.User.banner] = bannerPath
                }
            }
            
            if modifiedProperties[Constant.FirestoreTables.User.profilePicture] != nil {
                userService.uploadPicture(picture: profilePictureImageData, type: Constant.FirestoreTables.User.profilePicture) { [weak self] imagePath in
                    guard let profilePicturePath = imagePath else {
                        //TODO: Gérer l'erreur
                        return
                    }
                    // Fifth step -> Once we have the path, we add it in the modifiedProperties dictionnary.
                    modifiedProperties[Constant.FirestoreTables.User.profilePicture] = profilePicturePath
                }
            }
            
            // Last step -> We can save the user.
            userService.updateUser(fields: modifiedProperties) { [weak self] error in
                if let error = error {
                    //TODO: Gérer l'erreur
                    return
                }
                self?.userService.user = self?.changedUser
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
