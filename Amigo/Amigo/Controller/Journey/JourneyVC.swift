//
//  JourneyVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 08/05/2023.
//

import UIKit

class JourneyVC: UIViewController {
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupCell()
        fetchJourneyFLow()
        setupVoiceOver()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var journeyTableView: UITableView!
    @IBOutlet weak var fetchingAI: UIActivityIndicatorView!
    @IBOutlet weak var noJourneyLabel: UILabel!
    @IBOutlet weak var addDestinationButton: UIBarButtonItem!
    @IBOutlet weak var saveButtonAI: UIActivityIndicatorView!
    
    var trip: Trip?
    weak var delegate: JourneyVCDelegate?
    private let journeyFetchingService = JourneyFetchingService()
    private let journeyUpdateService = JourneyUpdateService()
    
    // MARK: - ACTIONS
    @IBAction func unwindToTripJourneyVC(segue: UIStoryboardSegue) {}
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        saveJourney()
    }
    
    @IBAction func addJourneyTapped(_ sender: Any) {
        performSegue(withIdentifier: Constant.SegueID.segueToCreateJourneyVC, sender: nil)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        saveButton.layer.cornerRadius = 10
    }
    
    private func setupCell() {
        self.journeyTableView.register(UINib(nibName: Constant.TableViewCells.journeyNibName, bundle: nil),
                                       forCellReuseIdentifier: Constant.TableViewCells.journeyCell)
    }
    
    private func fetchJourneyFLow() {
        guard let journey = trip?.journey else {
            fetchJourney()
            return
        }
        
        if let locations = journey.locations {
            // I am sorting the dates in ascending order, from the oldest to the newest.
            let dateOrderedJourney = LocationManagement.sortLocationsByDateAscending(locations: locations)
            trip?.journey?.locations = dateOrderedJourney
        }
        
        noJourneyLabel.isHidden = isJourneyEmpty()
        journeyTableView.reloadData()
        fetchingAI.isHidden = true
    }
    
    private func fetchJourney() {
        guard let tripID = trip?.tripID else { return }
        
        journeyFetchingService.fetchTripJourney(tripID: tripID) { [weak self] journey, error in
            if let error = error {
                self?.fetchingAI.isHidden = true
                self?.presentErrorAlert(with: error.localizedDescription)
                return
            }
            
            if var journey = journey, let locations = journey.locations {
                if !locations.isEmpty {
                    // I am sorting the dates in ascending order, from the oldest to the newest.
                    let dateOrderedJourney = LocationManagement.sortLocationsByDateAscending(locations: locations)
                    journey.locations = dateOrderedJourney
                    
                }
                
                // Saving the trip's journey.
                self?.trip?.journey = journey
                self?.delegate?.sendJourney(journey: journey)
                
                // Since we have the journey data available, we can display it in the TableView.
                self?.journeyTableView.reloadData()
                
                self?.noJourneyLabel.isHidden = true
            } else {
                self?.noJourneyLabel.isHidden = false
            }
            
            self?.fetchingAI.isHidden = true
        }
    }
    
    private func saveJourney() {
        guard let journey = trip?.journey, let tripID = trip?.tripID else {
            presentErrorAlert(with: Errors.DatabaseError.nothingToAdd.localizedDescription)
            return
        }
                
        do {
            UIViewController.toggleActivityIndicator(shown: true, button: saveButton, activityIndicator: saveButtonAI)

            // We update the journey in Firestore.
            try journeyUpdateService.updateJourney(journey: journey, for: tripID)
            
            // Propagating the modifications.
            delegate?.sendJourney(journey: journey)
            
            // And we can go back once it's saved.
            presentInformationAlert(with: "Your journey has been saved.") {
                self.navigationController?.popViewController(animated: true)
            }
        } catch let error as Errors.DatabaseError {
            presentErrorAlert(with: error.localizedDescription)
        } catch {
            presentErrorAlert(with: Errors.CommonError.defaultError.localizedDescription)
        }
    }
    
    private func setupVoiceOver() {
        saveButton.accessibilityHint = "Press the button to save your journey."
        addDestinationButton.accessibilityHint = "Press to add some destinations"
    }
    
    private func isJourneyEmpty() -> Bool {
        if let locations = trip?.journey?.locations, !locations.isEmpty {
            return true
        }
        return false
    }
}

// MARK: - EXTENSIONS & PROTOCOLS
extension JourneyVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constant.SegueID.segueToCreateJourneyVC:
            let createJourneyVC = segue.destination as? CreateJourneyVC
            createJourneyVC?.trip = trip
            //createJourneyVC?.journey = journey
            
            // To refresh the TableView later with the editedJourneys.
            createJourneyVC?.delegate = self

        default:
            return
        }
    }
}

extension JourneyVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trip?.journey?.locations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let locations = trip?.journey?.locations else { return UITableViewCell() }
        
        let location = locations[indexPath.row]
        
        guard let cell = journeyTableView.dequeueReusableCell(withIdentifier: Constant.TableViewCells.journeyCell, for: indexPath) as? JourneyTableViewCell else {
            return UITableViewCell()
        }
        
        let fullAddress = location.address + " " + location.city + " " + location.postalCode
        cell.configureCell(startDate: location.startDate.dateToString(), endDate: location.endDate.dateToString(), destination: fullAddress)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // We remove the location.
            trip?.journey?.locations?.remove(at: indexPath.row)
            
            // Deleting the cell.
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // In case the list became empty, we display the noJourneyLabel to the User.
            if let locations = trip?.journey?.locations, locations.isEmpty {
                noJourneyLabel.isHidden = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150)
    }
}

extension JourneyVC: CreateJourneyVCDelegate {
    func refreshJourney() {
        noJourneyLabel.isHidden = isJourneyEmpty()
        journeyTableView.reloadData()
    }
}

protocol JourneyVCDelegate: AnyObject {
    func sendJourney(journey: Journey)
}
