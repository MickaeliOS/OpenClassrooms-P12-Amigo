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
        fetchJourney()
        setupVoiceOver()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var journeyTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noJourneyLabel: UILabel!
    @IBOutlet weak var addDestinationButton: UIBarButtonItem!
    
    var trip: Trip?
    var journey: Journey?

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
    
    private func fetchJourney() {
        guard let tripID = trip?.tripID else { return }
        
        activityIndicator.isHidden = false
        
        journeyFetchingService.fetchTripJourney(tripID: tripID) { [weak self] journey, error in
            if let error = error {
                self?.noJourneyLabel.isHidden = false
                self?.activityIndicator.isHidden = true
                self?.presentErrorAlert(with: error.localizedDescription)
                return
            }
            
            if var journey = journey, let locations = journey.locations {
                // I am sorting the dates in ascending order, from the oldest to the newest.
                let dateOrderedJourney = LocationManagement.sortLocationsByDateAscending(locations: locations)
                journey.locations = dateOrderedJourney
                
                // Since we have the journey data available, we can display it in the TableView.
                self?.journey = journey
                self?.journeyTableView.reloadData()
            } else {
                self?.noJourneyLabel.isHidden = false
            }
            
            self?.activityIndicator.isHidden = true
        }
    }
    
    private func saveJourney() {
        guard let journey = journey, let tripID = trip?.tripID else {
            presentErrorAlert(with: Errors.DatabaseError.nothingToAdd.localizedDescription)
            return
        }
        
        do {
            try journeyUpdateService.updateJourney(journey: journey, for: tripID)
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
}

// MARK: - EXTENSIONS
extension JourneyVC {
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

extension JourneyVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journey?.locations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let locations = journey?.locations else { return UITableViewCell() }
        
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
            journey?.locations?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            if let locations = journey?.locations, locations.isEmpty {
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
        guard let locations = journey?.locations, !locations.isEmpty else {
            noJourneyLabel.isHidden = false
            return
        }
        noJourneyLabel.isHidden = true
        journeyTableView.reloadData()
    }
}
