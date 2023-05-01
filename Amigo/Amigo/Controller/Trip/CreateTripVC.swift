//
//  CreateTripVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 24/04/2023.
//

import UIKit

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
    @IBOutlet weak var tripDescriptionTextView: UITextView!
    @IBOutlet weak var addTripButton: UIButton!
    @IBOutlet weak var womanOnlyLabel: UILabel!
    @IBOutlet weak var womanOnlySwitch: UISwitch!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    let userAuth = UserAuth.shared
    let tripCreationService = TripCreationService()
    var countryName: String?
    let descriptionPlaceHolder = "Enter your description."
    var womanOnly = false
    
    // MARK: - ACTIONS
    @IBAction func unwindToCreateTripVC(segue: UIStoryboardSegue) {}
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        tripDescriptionTextView.resignFirstResponder()
    }

    @IBAction func addTripButtonTapped(_ sender: Any) {
        addTripFlow()
    }
    
    @IBAction func womanOnlySwitchTapped(_ sender: Any) {
        womanOnly = womanOnlySwitch.isOn ? true : false
    }
    
    @IBAction func destinationTextFieldTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "segueToDestinationPickerVC", sender: nil)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        addTripButton.layer.cornerRadius = 10
        
        // The text view's place holder
        tripDescriptionTextView.text = descriptionPlaceHolder
        tripDescriptionTextView.textColor = UIColor.placeholderText
        
        destinationTextField.addLeftSystemImage(image: UIImage(systemName: "airplane.departure")!)
        displayWomanOnlyInterface()
    }
    
    private func displayWomanOnlyInterface() {
        if userAuth.user?.gender != .woman {
            womanOnlyLabel.isHidden = true
            womanOnlySwitch.isHidden = true
        }
    }
    
    private func refreshCountryName() {
        destinationTextField.text = countryName
        
        // If we forgot to set the destination before, we need to hide the red message.
        if !errorMessageLabel.isHidden {
            errorMessageLabel.isHidden = true
        }

    }
    
    private func addTripFlow() {
        // We first make sure the mandatory fields are filled.
        guard fieldsControl() else {
            errorMessageLabel.displayErrorMessage(message: "These fields must be filled : \n - Destination \n - Description")
            return
        }
        
        // Then, we can create our Trip object.
        guard let trip = createTrip() else {
            return
        }
        
        // We can save the trip inside the Firestore database.
        tripCreationService.createTrip(trip: trip, for: userAuth.user!) { [weak self] error in
            if let error = error {
                self?.presentAlert(with: error.localizedDescription)
                return
            }
            
            self?.userAuth.user?.trips?.append(trip)
        }
    }
    
    private func createTrip() -> Trip? {
        guard let currentUser = userAuth.user else {
            presentAlert(with: "An error occured, please reconnect.")
            return nil
        }
        
        // We can now safely create our trip, with womanOnly if our user is a female who wished for female only trip.
        var trip = Trip(user: userAuth.user!,
                        startDate: startDatePicker.date,
                        endDate: endDatePicker.date,
                        destination: destinationTextField.text!,
                        description: tripDescriptionTextView.text!)
        
        if userAuth.user?.gender == .woman {
            trip.womanOnly = womanOnly
            return nil
        }
        
        return trip
    }
    
    private func fieldsControl() -> Bool {
        guard !destinationTextField.isEmpty, !tripDescriptionTextView.isEmpty else {
            return false
        }
        return true
    }
}

// MARK: - EXTENSIONS
extension CreateTripVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationPickerVC = segue.destination as? DestinationPickerVC {
            destinationPickerVC.delegate = self
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

extension CreateTripVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        errorMessageLabel.isHidden = true
        return true
    }
}
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
