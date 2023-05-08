//
//  TripDetailVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 08/05/2023.
//

import UIKit

class TripDetailVC: UIViewController {
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var journeyButton: UIButton!
    @IBOutlet weak var moneySpentButton: UIButton!
    @IBOutlet weak var toDoListButton: UIButton!
    @IBOutlet weak var ticketsButton: UIButton!
    
    var trip: Trip?
    
    // MARK: - ACTIONS
    @IBAction func journeyButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: Constant.SegueID.segueToTripJourneyVC, sender: trip)
    }
    
    @IBAction func moneySpentButtonTapped(_ sender: Any) {
    }
    
    @IBAction func toDoListButtonTapped(_ sender: Any) {
    }
    
    @IBAction func ticketsButtonTapped(_ sender: Any) {
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        guard let trip = trip else { return }
        
        countryNameLabel.text = trip.country
        startDatePicker.date = trip.startDate
        endDatePicker.date = trip.endDate
        startDatePicker.minimumDate = Date()
        endDatePicker.minimumDate = Date()
    }
}

extension TripDetailVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueID.segueToTripJourneyVC {
            let tripJourneyVC = segue.destination as? TripJourneyVC
            let trip = sender as? Trip
            tripJourneyVC?.trip = trip
        }
    }
}
