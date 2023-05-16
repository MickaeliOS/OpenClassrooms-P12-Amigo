//
//  TripVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 14/04/2023.
//

import UIKit
import FirebaseAuth

class TripVC: UIViewController {
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCell()
        startLoginFlow()
        setupVoiceOver()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var tripTableView: UITableView!
    @IBOutlet weak var noTripLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addTripButton: UIBarButtonItem!

    var user: User?
    private let currentUser = Auth.auth().currentUser
    private let userFetchingService = UserFetchingService()
    private let tripFetchingService = TripFetchingService()
    private let tripDeletionService = TripDeletionService()
    private let journeyDeletionService = JourneyDeletionService()
    private let expenseDeletionService = ExpenseDeletionService()
    
    // MARK: - ACTIONS
    @IBAction func unwindToRootVC(segue: UIStoryboardSegue) {
        if segue.source is CreateAccountVC || segue.source is WelcomeVC {
            startLoginFlow()
        }
        
        if segue.source is ConfirmationTripVC {
            refreshInterface()
            sortTripsByDateAscending()
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupCell() {
        self.tripTableView.register(UINib(nibName: Constant.TableViewCells.tripNibName, bundle: nil),
                                    forCellReuseIdentifier: Constant.TableViewCells.tripCell)
    }
    
    private func startLoginFlow() {
        guard let currentUser = currentUser else {
            presentVCFullScreen(with: "WelcomeVC")
            return
        }

        activityIndicator.isHidden = false
        
        Task {
            do {
                // First, we fetch the user from Firestore
                user = try await userFetchingService.fetchUser(userID: currentUser.uid)
                
                // We also need the user's trips.
                user?.trips = try await tripFetchingService.fetchTrips(userID: currentUser.uid)
                
                // It's necessary to display the trips in ascending order based on the date, starting from the oldest.
                sortTripsByDateAscending()

                refreshInterface()
                
            } catch let error as Errors.DatabaseError {
                presentErrorAlert(with: error.localizedDescription)
            }
        }
    }
    
    private func isUserTripsEmpty() -> Bool {
        if let trips = user?.trips, !trips.isEmpty {
            return true
        }
        return false
    }
    
    private func refreshInterface() {
        tripTableView.reloadData()
        activityIndicator.isHidden = true
        noTripLabel.isHidden = isUserTripsEmpty()
    }
    
    private func setupVoiceOver() {
        addTripButton.accessibilityHint = "Press to add a trip."
    }
    
    private func sortTripsByDateAscending() {
        guard let trips = user?.trips, !trips.isEmpty else { return }

        user?.trips = TripManagement.sortTripsByDateAscending(trips: trips)
    }
}

// MARK: - EXTENSIONS
extension TripVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueID.segueToTripDetailVC {
            let tripDetailVC = segue.destination as? TripDetailVC
            let trip = sender as? Trip
            tripDetailVC?.trip = trip
            tripDetailVC?.delegate = self
        }
    }
}

extension TripVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.trips?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableViewCells.tripCell,
                                                       for: indexPath) as? TripTableViewCell else {
            return UITableViewCell()
        }
        
        guard let trip = user?.trips?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configureCell(country: trip.country,
                           countryCode: trip.countryCode,
                           fromDate: trip.startDate,
                           toDate: trip.endDate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trip = user?.trips?[indexPath.row]
        performSegue(withIdentifier: Constant.SegueID.segueToTripDetailVC, sender: trip)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(120)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            presentDestructiveAlert(with: "Are you sure you want to delete your Trip ?") {
                Task {
                    do {
                        guard let tripID = self.user?.trips?[indexPath.row].tripID else {
                            self.presentErrorAlert(with: Errors.DatabaseError.noTripID.localizedDescription)
                            return
                        }
                        
                        // Always remove the data first
                        try await self.tripDeletionService.deleteTrip(tripID: tripID)
                        try await self.journeyDeletionService.deleteJourney(tripID: tripID)
                        try await self.expenseDeletionService.deleteExpense(tripID: tripID)

                        self.user?.trips?.remove(at: indexPath.row)
                        
                        // Then, the cell
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        
                        self.noTripLabel.isHidden = self.isUserTripsEmpty()
                    } catch let error as Errors.DatabaseError {
                        self.presentErrorAlert(with: error.localizedDescription)
                    }
                }
            }
        }
    }
}

extension TripVC: TripDetailVCDelegate {
    func refreshTrip() {
        guard let currentUser = currentUser else {
            presentErrorAlert(with: Errors.CommonError.noUser.localizedDescription)
            return
        }
        
        activityIndicator.isHidden = false
        
        // In the rare case where the trip has been deleted by an external actor,
        // we re-fetch them to have the latest ones.
        Task {
            do {
                user?.trips = try await tripFetchingService.fetchTrips(userID: currentUser.uid)
            } catch let error as Errors.DatabaseError {
                presentErrorAlert(with: error.localizedDescription)
            }
            
            refreshInterface()
        }
    }
}
