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
        setupVoiceOver()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var addTripButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var countryInformations: (String, String)?
    private var dataSource: MyTabBarVC { tabBarController as! MyTabBarVC }
    private let currentUser = Auth.auth().currentUser
    private let tripCreationService = TripCreationService()
    private let descriptionPlaceHolder = "Enter your description."
    
    // MARK: - ACTIONS
    @IBAction func unwindToCreateTripVC(segue: UIStoryboardSegue) {}
    
    @IBAction func addTripButtonTapped(_ sender: Any) {
        addTripFlow()
    }
    
    @IBAction func destinationTextFieldTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: Constant.SegueID.segueToCountryPickerVC, sender: nil)
    }
    
    @IBAction func startDateTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func endDateTapped(_ sender: Any) {
        self.dismiss(animated: true)
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
        
        do {
            UIViewController.toggleActivityIndicator(shown: true, button: addTripButton, activityIndicator: activityIndicator)
            
            // We can save the trip inside the Firestore database.
            let tripID = try tripCreationService.createTrip(trip: trip)
            
            // The retrieval of the tripID is essential for any future editing or deletion of the corresponding trip.
            trip.tripID = tripID
            
            // Let's add the trip locally.
            addTrip(trip: trip)
            
            // We can go to the ConfirmationVC screen.
            performSegue(withIdentifier: Constant.SegueID.segueToConfirmationTripVC, sender: nil)
            
        } catch let error as Errors.DatabaseError {
            presentErrorAlert(with: error.localizedDescription)
        } catch {
            presentErrorAlert(with: Errors.CommonError.defaultError.localizedDescription)
        }
        
        UIViewController.toggleActivityIndicator(shown: false, button: addTripButton, activityIndicator: activityIndicator)
    }
    
    private func createTrip() -> Trip? {
        // We need to control if we have a user logged in, because we need his uid to create a trip.
        guard let currentUser = currentUser else {
            presentErrorAlert(with: Errors.CommonError.noUser.localizedDescription)
            return nil
        }
        
        // We make sure that we have a destination.
        guard let countryInformations = countryInformations else {
            errorMessageLabel.displayErrorMessage(message: "Please select a destination.")
            return nil
        }
        
        // startDate should be < to endDate
        guard startDatePicker.date <= endDatePicker.date else {
            errorMessageLabel.displayErrorMessage(message: "Please select a correct interval of dates.")
            return nil
        }
        
        // We can now safely create our trip
        let trip = Trip(userID: currentUser.uid,
                        startDate: startDatePicker.date,
                        endDate: endDatePicker.date,
                        country: countryInformations.0,
                        countryCode: countryInformations.1)
        return trip
    }
    
    private func addTrip(trip: Trip) {
        // We locally save the trip. If trip is nil, indicating that the user has not retrieved their list of trips, we allow the addition of the current trip without blocking them.
        if dataSource.user?.trips == nil {
            dataSource.user?.trips = [trip]
        } else {
            dataSource.user?.trips?.append(trip)
        }
    }
    
    private func refreshCountryName() {
        // "countryInformations?.0" is the country name.
        destinationTextField.text = countryInformations?.0
        
        // We hide the errorMessage in case it was displayed.
        errorMessageLabel.isHidden = true
    }
    
    private func setupVoiceOver() {
        // Labels
        startDatePicker.accessibilityLabel = "Trip's start date."
        endDatePicker.accessibilityLabel = "Trip's end date."
        
        // Values
        startDatePicker.accessibilityValue = startDatePicker.date.dateToString()
        endDatePicker.accessibilityValue = endDatePicker.date.dateToString()
        
        // Hints
        addTripButton.accessibilityHint = "Press to add your trip."
    }
}

// MARK: - EXTENSIONS & PROTOCOLS
extension CreateTripVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
