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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.refreshTrip()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var journeyButton: UIButton!
    @IBOutlet weak var moneySpentButton: UIButton!
    @IBOutlet weak var toDoListButton: UIButton!
    @IBOutlet weak var ticketsButton: UIButton!
    
    weak var delegate: TripDetailVCDelegate?
    var trip: Trip?
    
    // MARK: - ACTIONS
    @IBAction func journeyButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: Constant.SegueID.segueToTripJourneyVC, sender: trip)
    }
    
    @IBAction func moneySpentButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: Constant.SegueID.segueToExpensesVC, sender: trip)
    }
    
    @IBAction func toDoListButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: Constant.SegueID.segueToToDoList, sender: trip)
    }

    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        guard let trip = trip else { return }
        
        countryNameLabel.text = trip.country
        startDateLabel.text = trip.startDate.dateToString()
        endDateLabel.text = trip.endDate.dateToString()
    }
}

// MARK: - EXTENSIONS
extension TripDetailVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let trip = sender as? Trip

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
    func refreshTrip()
}
