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
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var tripTableView: UITableView!
    @IBOutlet weak var noTripLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var userAuth = UserAuth.shared
    private let userFetchingService = UserFetchingService()
    private let tripFetchingService = TripFetchingService()
    private let tripDeletionService = TripDeletionService()
        
    // MARK: - ACTIONS
    @IBAction func unwindToRootVC(segue: UIStoryboardSegue) {
        if segue.source is CreateAccountVC || segue.source is WelcomeVC {
            startLoginFlow()
        }
        
        if segue.source is ConfirmationTripVC {
            tripTableView.reloadData()
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupCell() {
        self.tripTableView.register(UINib(nibName: Constant.TableViewCells.tripNibName, bundle: nil),
                                    forCellReuseIdentifier: Constant.TableViewCells.tripCell)
    }
    
    private func startLoginFlow() {
        guard userAuth.currentlyLoggedIn else {
            presentVCFullScreen(with: "WelcomeVC")
            return
        }
        
        activityIndicator.isHidden = false
        
        Task {
            do {
                // First, we fetch the user from Firestore
                try await userFetchingService.fetchUser()
                
                // Once we have the complete user, we need to fetch his trips to display them in the tripTableView
                userAuth.user?.trips = try await tripFetchingService.fetchUserTrips()
                
                // It's necessary to display the trips in ascending order based on the date, starting from the oldest.
                if let trips = userAuth.user?.trips, !trips.isEmpty {
                    userAuth.user?.trips = TripManagement.sortTripsByDateAscending(trips: trips)
                    tripTableView.reloadData()
                }
                
                activityIndicator.isHidden = true
                noTripLabel.isHidden = userAuth.user?.trips != nil ? true : false
                
            } catch let error as Errors.DatabaseError where error == .noUser {
                presentErrorAlert(with: error.localizedDescription) {
                    self.presentVCFullScreen(with: "WelcomeVC")
                }
            } catch let error as Errors.DatabaseError {
                presentErrorAlert(with: error.localizedDescription)
            }
        }
    }
}

// MARK: - EXTENSIONS
extension TripVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueID.segueToTripDetailVC {
            let tripDetailVC = segue.destination as? TripDetailVC
            let trip = sender as? Trip
            tripDetailVC?.trip = trip
        }
    }
}

extension TripVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAuth.user?.trips?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableViewCells.tripCell,
                                                       for: indexPath) as? TripTableViewCell else {
            return UITableViewCell()
        }
        
        guard let trip = userAuth.user?.trips?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configureCell(country: trip.country,
                           countryCode: trip.countryCode,
                           fromDate: trip.startDate,
                           toDate: trip.endDate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trip = userAuth.user?.trips?[indexPath.row]
        performSegue(withIdentifier: Constant.SegueID.segueToTripDetailVC, sender: trip)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            Task {
                do {
                    guard let tripID = userAuth.user?.trips?[indexPath.row].tripID else {
                        presentErrorAlert(with: Errors.DatabaseError.noTripID.localizedDescription)
                        return
                    }
                    
                    // Always remove the data first
                    try await tripDeletionService.deleteTrip(tripID: tripID)
                    userAuth.user?.trips?.remove(at: indexPath.row)
                    
                    // Then, the cell
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                } catch let error as Errors.DatabaseError {
                    presentErrorAlert(with: error.localizedDescription)
                }
            }
        }
    }
}
