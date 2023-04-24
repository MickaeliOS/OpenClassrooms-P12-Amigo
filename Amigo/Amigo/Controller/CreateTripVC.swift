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

    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tripDescriptionTextView: UITextView!
    @IBOutlet weak var findTripButton: UIButton!
    
    // MARK: - ACTIONS
    @IBAction func findTripButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func destinationTextFieldTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "segueToDestinationPickerVC", sender: nil)
    }
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        findTripButton.layer.cornerRadius = 10
        
    }
}
