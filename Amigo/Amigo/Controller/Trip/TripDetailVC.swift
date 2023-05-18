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
        setupVoiceOver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // If the back button is pressed, I need to update the trip in the dataSource property to ensure data synchronization.
        if isMovingFromParent {
            guard let trip = trip else { return }
            delegate?.updateTrip(trip: trip)
        }
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var journeyButton: UIButton!
    @IBOutlet weak var expensesButton: UIButton!
    @IBOutlet weak var toDoListButton: UIButton!
    
    var trip: Trip?
    weak var delegate: TripDetailVCDelegate?
    
    // MARK: - ACTIONS
    @IBAction func journeyButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: Constant.SegueID.segueToTripJourneyVC, sender: trip)
    }
    
    @IBAction func expensesButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: Constant.SegueID.segueToExpensesVC, sender: trip)
    }
    
    @IBAction func toDoListButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: Constant.SegueID.segueToToDoList, sender: trip)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        guard let trip = trip else { return }
        
        // Labels
        let countryFlag = String.countryFlag(countryCode: trip.countryCode)
        countryNameLabel.text = countryFlag + " " + trip.country
        startDateLabel.text = trip.startDate.dateToString()
        endDateLabel.text = trip.endDate.dateToString()
        
        // Buttons
        journeyButton.layer.cornerRadius = 10
        expensesButton.layer.cornerRadius = 10
        toDoListButton.layer.cornerRadius = 10
    }
    
    private func setupVoiceOver() {
        // Labels
        startDateLabel.accessibilityLabel = "The trip's start date."
        endDateLabel.accessibilityLabel = "The trip's end date."
        
        // Values
        startDateLabel.accessibilityValue = startDateLabel.text
        endDateLabel.accessibilityValue = endDateLabel.text
        
        // Hints
        journeyButton.accessibilityHint = "Press to see the trip's journey."
        expensesButton.accessibilityHint = "Press to see the trip's expenses."
        toDoListButton.accessibilityHint = "Press to see the trip's to do list."
    }
}

// MARK: - EXTENSIONS & PROTOCOLS
extension TripDetailVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let trip = sender as? Trip
        
        // Before accessing any of the available features, it is necessary to pass the relevant Trip object.
        switch segue.identifier {
            
        case Constant.SegueID.segueToTripJourneyVC:
            let tripJourneyVC = segue.destination as? JourneyVC
            tripJourneyVC?.trip = trip
            
        case Constant.SegueID.segueToToDoList:
            let toDoListVC = segue.destination as? ToDoListVC
            toDoListVC?.trip = trip
            toDoListVC?.delegate = self
            
        case Constant.SegueID.segueToExpensesVC:
            let expensesVC = segue.destination as? ExpensesVC
            expensesVC?.trip = trip
            expensesVC?.delegate = self
        default:
            return
        }
    }
}

extension TripDetailVC: ToDoListVCDelegate {
    func getTripFromToDoListVC(trip: Trip) {
        self.trip = trip
    }
}

extension TripDetailVC: ExpensesVCDelegate {
    func getTripFromExpensesVC(trip: Trip) {
        self.trip = trip
    }
}

protocol TripDetailVCDelegate: AnyObject {
    func updateTrip(trip: Trip)
}
