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
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tripDescriptionTextView: UITextView!
    @IBOutlet weak var findTripButton: UIButton!
    var countryName: String?
    
    // MARK: - ACTIONS
    @IBAction func unwindToCreateTripVC(segue: UIStoryboardSegue) {}

    @IBAction func findTripButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func destinationTextFieldTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "segueToDestinationPickerVC", sender: nil)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        findTripButton.layer.cornerRadius = 10
    }
    
    private func refreshCountryName() {
        destinationTextField.text = countryName
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
