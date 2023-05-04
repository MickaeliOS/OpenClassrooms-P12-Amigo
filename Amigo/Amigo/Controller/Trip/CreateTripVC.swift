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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    let descriptionPlaceHolder = "Enter your description."
    
    var tripDestination: Destination?
    var womanOnly = false
    weak var delegate: CreateTripVCDelegate?
    
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
        
        destinationTextField.addLeftSystemImage(image: UIImage(systemName: "airplane.circle")!)
        displayGenderSpecificInterface()
    }
    
    private func displayGenderSpecificInterface() {
        if userAuth.user?.gender != .woman {
            womanOnlyLabel.isHidden = true
            womanOnlySwitch.isHidden = true
        }
    }
    
    private func refreshCountryName() {
        // For more clarity, i'm only displaying the first part of the address.
        destinationTextField.text = tripDestination?.address
        
        // If we forgot to set the destination before pressing the Add Trip Button,
        // the red error message is displayed, and when we set the destination, we
        // make it disapear.
        if !errorMessageLabel.isHidden {
            errorMessageLabel.isHidden = true
        }
    }
    
    private func addTripFlow() {
        guard let trip = createTrip() else {
            presentAlert(with: Errors.CommonError.defaultError.localizedDescription)
            return
        }
        
        // We can save the trip inside the Firestore database.
        tripCreationService.createTrip(trip: trip) { [weak self] error in
            if let error = error {
                self?.presentAlert(with: error.localizedDescription)
                return
            }

            // We head back to the previous screen.
            self?.delegate?.passCreatedTripToFindTripVC(trip: trip)
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func createTrip() -> Trip? {
        guard let _ = userAuth.user else {
            presentAlert(with: "An error occured, please reconnect.")
            return nil
        }
        
        // We first make sure the mandatory fields are filled.
        guard fieldsControl() else {
            errorMessageLabel.displayErrorMessage(message: "These fields must be filled : \n - Destination \n - Description")
            return nil
        }
            
        // We can now safely create our trip, with womanOnly if our user is a female who wished for a female only trip.
        var trip = Trip(userID: userAuth.user!.userID,
                        startDate: startDatePicker.date,
                        endDate: endDatePicker.date,
                        description: tripDescriptionTextView.text!,
                        destination: tripDestination!)
        
        if userAuth.user?.gender == .woman {
            trip.womanOnly = womanOnly
        }
        
        return trip
    }
    
    private func fieldsControl() -> Bool {
        guard tripDestination != nil,
              !tripDescriptionTextView.isEmpty,
              tripDescriptionTextView.text != descriptionPlaceHolder else {
            return false
        }
        return true
    }
}

// MARK: - EXTENSIONS & PROTOCOLS
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

protocol CreateTripVCDelegate: AnyObject {
    func passCreatedTripToFindTripVC(trip: Trip)
}
