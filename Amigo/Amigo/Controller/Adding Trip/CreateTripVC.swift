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
    
    var countryInformations: (String, String)?
    
    // MARK: - ACTIONS
    @IBAction func unwindToCreateTripVC(segue: UIStoryboardSegue) {}
    
    @IBAction func addTripButtonTapped(_ sender: Any) {
        addTripFlow()
    }

    @IBAction func destinationTextFieldTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: Constant.SegueID.segueToCountryPickerVC, sender: nil)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        addTripButton.layer.cornerRadius = 10
        destinationTextField.addLeftSystemImage(image: UIImage(systemName: "airplane.circle")!)
        startDatePicker.minimumDate = Date()
        endDatePicker.minimumDate = Date()
    }
    
    private func addTripFlow() {
        guard var trip = createTrip() else {
            return
        }
        
        // We can save the trip inside the Firestore database.
        do {
            let tripID = try tripCreationService.createTrip(trip: trip)
            
            // The retrieval of the tripID is essential for any future editing or deletion of the corresponding trip.
            trip.tripID = tripID
            
            // We can go to the ConfirmationVC screen.
            performSegue(withIdentifier: Constant.SegueID.segueToConfirmationTripVC, sender: trip)
            
        } catch let error as Errors.DatabaseError {
            presentAlert(with: error.localizedDescription)
        } catch {
            presentAlert(with: Errors.CommonError.defaultError.localizedDescription)
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
        guard let countryInformations = countryInformations else {
            errorMessageLabel.displayErrorMessage(message: "Please select a destination.")
            return nil
        }
        
        // We can now safely create our trip
        let trip = Trip(userID: currentUserID,
                        startDate: startDatePicker.date,
                        endDate: endDatePicker.date,
                        country: countryInformations.0,
                        countryCode: countryInformations.1)
        return trip
    }
    
    private func refreshCountryName() {
        destinationTextField.text = countryInformations?.0
        
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
            let trip = sender as? Trip
            confirmationTripVC?.trip = trip
        }
        
        if segue.identifier == Constant.SegueID.segueToCountryPickerVC {
            let destinationPickerVC = segue.destination as? CountryPickerVC
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

extension CreateTripVC: CountryPickerVCDelegate {
    func refreshCountryNameFromPicker() {
        // When DestinationPickerVC disappear, it communicates the new country name.
        // We refresh the country name inside our UILabel to be displayed.
        refreshCountryName()
    }
}
