//
//  ConfirmationTripVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 04/05/2023.
//

import UIKit

class ConfirmationTripVC: UIViewController {
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
}

// MARK: - EXTENSIONS & PROTOCOL
extension ConfirmationTripVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueID.unwindToRootVC {
            guard let trip = sender as? Trip else { return }
            let rootVC = segue.destination as? TripVC
            rootVC?.trips?.append(trip)
        }
    }
}
