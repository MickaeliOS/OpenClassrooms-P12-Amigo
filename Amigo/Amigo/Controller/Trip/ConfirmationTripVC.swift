//
//  ConfirmationTripVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 04/05/2023.
//

import UIKit

class ConfirmationTripVC: UIViewController {
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupVoiceOver()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var myListButton: UIButton!
    var trip: Trip?

    // MARK: - ACTIONS
    @IBAction func myListButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: Constant.SegueID.unwindToRootVC, sender: trip)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        myListButton.layer.cornerRadius = 10
    }
    
    private func setupVoiceOver() {
        myListButton.accessibilityHint = "Press to get back to your trip's list."
    }
}

// MARK: - EXTENSIONS
extension ConfirmationTripVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueID.unwindToRootVC {
            let tripVC = segue.destination as? TripVC
            guard let trip = sender as? Trip else { return }
            tripVC?.user?.trips?.append(trip)
        }
    }
}
