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
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var journeyTableView: UITableView!
    
    var trip: Trip?
    var editedTrip: Trip?
    private let tripUpdateService = TripUpdateService()
    
    // MARK: - ACTIONS
    @IBAction func unwindToTripJourneyVC(segue: UIStoryboardSegue) {}
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        saveEditedTrip()
    }
    
    @IBAction func addJourneyTapped(_ sender: Any) {
        performSegue(withIdentifier: Constant.SegueID.segueToCreateJourneyVC, sender: editedTrip)
    }
    
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        saveButton.layer.cornerRadius = 10
        editedTrip = trip
    }
    
    private func setupCell() {
        self.journeyTableView.register(UINib(nibName: Constant.TableViewCells.journeyNibName, bundle: nil),
                                    forCellReuseIdentifier: Constant.TableViewCells.journeyCell)
    }
    
    private func saveEditedTrip() {
        // Nothing to save.
        guard trip != editedTrip else { return }
        guard let editedTrip = editedTrip else { return }
        
        guard let journeyList = editedTrip.journeyList, let tripID = editedTrip.tripID else { return }
        
        Task {
            do {
                try await tripUpdateService.updateJourneyList(journeyList: journeyList, for: tripID)
            } catch let error as Errors.DatabaseError {
                presentAlert(with: error.localizedDescription)
            }
        }
    }
}

// MARK: - EXTENSIONS
extension TripJourneyVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueID.segueToCreateJourneyVC {
            let createJourneyVC = segue.destination as? CreateJourneyVC
            let editedTrip = sender as? Trip
            createJourneyVC?.editedTrip = editedTrip
            
            // To refresh the TableView later with the editedJourneys.
            createJourneyVC?.delegate = self
        }
    }
}

extension TripJourneyVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editedTrip?.journeyList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let journeyList = editedTrip?.journeyList else { return UITableViewCell() }
        
        let journey = journeyList[indexPath.row]
        
        guard let cell = journeyTableView.dequeueReusableCell(withIdentifier: Constant.TableViewCells.journeyCell, for: indexPath) as? JourneyTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(startDate: journey.startDate.dateToString(), endDate: journey.endDate.dateToString(), destination: journey.address)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
}

extension TripJourneyVC: CreateJourneyVCDelegate {
    func refreshJourneyList() {
        journeyTableView.reloadData()
    }
}
