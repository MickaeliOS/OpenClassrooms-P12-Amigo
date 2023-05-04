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
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var myListButton: UIButton!
    var trip: Trip?

    // MARK: - ACTIONS
    @IBAction func myListButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "unwindToRootVC", sender: trip)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        myListButton.layer.cornerRadius = 10
    }
}

// MARK: - EXTENSIONS & PROTOCOL
extension ConfirmationTripVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToRootVC" {
            let rootVC = segue.destination as? AddTripVC
            let trip = sender as? Trip
            rootVC?.trips?.append(trip!)//TODO: déballage forcé, j'aime pas
        }
    }
}
