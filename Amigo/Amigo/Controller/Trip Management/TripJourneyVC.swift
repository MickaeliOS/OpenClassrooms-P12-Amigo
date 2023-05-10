//
//  TripJourneyVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 08/05/2023.
//

import UIKit

class TripJourneyVC: UIViewController {
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupCell()
        fetchJourney()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var journeyTableView: UITableView!
    
    var trip: Trip?
    var journey: Journey?

    private var userAuth = UserAuth.shared
    private let journeyFetchingService = JourneyFetchingService()
    private let journeyUpdateService = JourneyUpdateService()
    
    // MARK: - ACTIONS
    @IBAction func unwindToTripJourneyVC(segue: UIStoryboardSegue) {}
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        //saveEditedTrip()
        saveJourney()
    }
    
    @IBAction func addJourneyTapped(_ sender: Any) {
        performSegue(withIdentifier: Constant.SegueID.segueToCreateJourneyVC, sender: nil)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        saveButton.layer.cornerRadius = 10
        //editedTrip = trip
    }
    
    private func setupCell() {
        self.journeyTableView.register(UINib(nibName: Constant.TableViewCells.journeyNibName, bundle: nil),
                                    forCellReuseIdentifier: Constant.TableViewCells.journeyCell)
    }
    
    private func fetchJourney() {
        guard let tripID = trip?.tripID else { return }
        
        Task {
            do {
                let journey = try await journeyFetchingService.fetchTripJourney(tripID: tripID)
                self.journey = journey
                journeyTableView.reloadData()
            } catch let error as Errors.DatabaseError {
                presentAlert(with: error.localizedDescription)
            }
        }
    }
    
    private func saveJourney() {
        guard let journey = journey, let tripID = trip?.tripID else { return }
        
        do {
            try journeyUpdateService.updateJourney(journey: journey, for: tripID)

        } catch let error as Errors.DatabaseError {
            presentAlert(with: error.localizedDescription)
        } catch {
            presentAlert(with: Errors.CommonError.defaultError.localizedDescription)
        }
    }
    
    /*private func saveEditedTrip() {
        // Nothing to save.
        guard trip != editedTrip else { return }
        guard let editedTrip = editedTrip else { return }
        
        guard let journeyList = editedTrip.journey, let tripID = editedTrip.tripID else { return }
        
        Task {
            do {
                try await tripUpdateService.updateJourney(journey: journeyList, for: tripID)
            } catch let error as Errors.DatabaseError {
                presentAlert(with: error.localizedDescription)
            }
        }
    }*/
}

// MARK: - EXTENSIONS
extension TripJourneyVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueID.segueToCreateJourneyVC {
            let createJourneyVC = segue.destination as? CreateJourneyVC
            createJourneyVC?.trip = trip
            createJourneyVC?.journey = journey
            
            // To refresh the TableView later with the editedJourneys.
            createJourneyVC?.delegate = self
        }
    }
}

extension TripJourneyVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journey?.locations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let locations = journey?.locations else { return UITableViewCell() }
        
        let location = locations[indexPath.row]
        
        guard let cell = journeyTableView.dequeueReusableCell(withIdentifier: Constant.TableViewCells.journeyCell, for: indexPath) as? JourneyTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(startDate: location.startDate.dateToString(), endDate: location.endDate.dateToString(), destination: location.address)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
}

extension TripJourneyVC: CreateJourneyVCDelegate {
    func refreshJourney() {
        journeyTableView.reloadData()
    }
}
