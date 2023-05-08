//
//  CreateTripVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 24/04/2023.
//

import UIKit
import FirebaseAuth

class CreateTripVC: UIViewController {
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var addTripButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    private let userAuth = UserAuth.shared
    private let tripCreationService = TripCreationService()
    private let descriptionPlaceHolder = "Enter your description."
    
    var tripDestination: Destination?
    
    // MARK: - ACTIONS
    @IBAction func unwindToCreateTripVC(segue: UIStoryboardSegue) {}
    
    @IBAction func addTripButtonTapped(_ sender: Any) {
        addTripFlow()
    }

    @IBAction func destinationTextFieldTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: Constant.SegueID.segueToDestinationPickerVC, sender: nil)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        addTripButton.layer.cornerRadius = 10
        destinationTextField.addLeftSystemImage(image: UIImage(systemName: "airplane.circle")!)
    }
    
    private func addTripFlow() {
        guard let trip = createTrip() else {
            return
        }
        
        // We can save the trip inside the Firestore database.
        tripCreationService.createTrip(trip: trip) { [weak self] error in
            if let error = error {
                self?.presentAlert(with: error.localizedDescription)
                return
            }

            // We can go to the ConfirmationVC screen.
            self?.performSegue(withIdentifier: Constant.SegueID.segueToConfirmationTripVC, sender: trip)
        }
    }
    
    private func destinationControl() -> Bool {
        return destinationTextField.isEmpty
    }
    
    private func createTrip() -> Trip? {
        // We need to control if we have a user logged in.
        guard let currentUserID = userAuth.currentUser?.uid else {
            presentAlert(with: Errors.CommonError.noUser.localizedDescription) {
                self.presentVCFullScreen(with: "WelcomeVC")
            }
            return nil
        }
        
        // We make sure that we have a destination.
        guard let tripDestination = tripDestination else {
            errorMessageLabel.displayErrorMessage(message: "Please select a destination.")
            return nil
        }
        
        // We can now safely create our trip
        let trip = Trip(userID: currentUserID,
                        startDate: startDatePicker.date,
                        endDate: endDatePicker.date,
                        destination: tripDestination)
        return trip
    }
    
    private func refreshCountryName() {
        destinationTextField.text = tripDestination?.country
        
        // If we forgot to set the destination before pressing the Add Trip Button,
        // the red error message is displayed, and when we set the destination, we
        // make it disapear.
        if !errorMessageLabel.isHidden {
            errorMessageLabel.isHidden = true
        }
    }
}

// MARK: - EXTENSIONS & PROTOCOLS
extension CreateTripVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueID.segueToConfirmationTripVC {
            let confirmationTripVC = segue.destination as? ConfirmationTripVC
            let destination = sender as? Trip
            confirmationTripVC?.trip = destination
        }
        
        if segue.identifier == Constant.SegueID.segueToDestinationPickerVC {
            let destinationPickerVC = segue.destination as? DestinationPickerVC
            destinationPickerVC?.delegate = self
        }
    }
}

extension CreateTripVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        errorMessageLabel.isHidden = true
        return true
    }
}

// Manual gestion of placeHolder for our textView
extension CreateTripVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        errorMessageLabel.isHidden = true
        
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

extension CreateTripVC: DestinationPickerVCDelegate {
    func destinationPickerVCDidDismiss() {
        // When DestinationPickerVC disappear, it communicates the new country name.
        // We refresh the country name inside our UILabel to be displayed.
        refreshCountryName()
    }
}
