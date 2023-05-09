//
//  CreateJourneyVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 08/05/2023.
//

import UIKit
import MapKit

class CreateJourneyVC: UIViewController {
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapKitAutocompletion()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        performSegue(withIdentifier: Constant.SegueID.unwindToTripJourneyVC, sender: editedTrip)
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var journeySearchBar: UISearchBar!
    @IBOutlet weak var journeyTableView: UITableView!
    @IBOutlet weak var addJourneyButton: UIButton!
    
    var editedTrip: Trip?
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    weak var delegate: CreateJourneyVCDelegate?
    
    // MARK: - ACTIONS
    @IBAction func addJourneyTapped(_ sender: Any) {
        saveJourney()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func setupInterface() {
        guard let editedTrip = editedTrip else { return }
        
        startDatePicker.minimumDate = editedTrip.startDate
        endDatePicker.minimumDate = editedTrip.endDate
        journeySearchBar.becomeFirstResponder()
        addJourneyButton.layer.cornerRadius = 10
    }
    
    private func setupMapKitAutocompletion() {
        searchCompleter.delegate = self
    }
    
    private func saveJourney() {
        guard let completeAddress = journeySearchBar.text else { return }
        
        MKLocalSearch.getPartsFromAddress(address: completeAddress) { [weak self] result, error in
            guard error == nil, let result = result else {
                return
            }
            
            let journey = Journey(address: result.placemark.name ?? "N/A",
                                  postalCode: result.placemark.postalCode ?? "N/A",
                                  city: result.placemark.locality ?? "N/A",
                                  startDate: (self?.startDatePicker.date)!,
                                  endDate: (self?.endDatePicker.date)!)
            
            if self?.editedTrip?.journeyList == nil {
                var journeyList = [Journey]()
                journeyList.append(journey)
                self?.editedTrip?.journeyList = journeyList
            } else {
                self?.editedTrip?.journeyList?.append(journey)
                self?.journeySearchBar.text = ""
            }
        }
    }
}

// MARK: - EXTENSIONS & PROTOCOLS
extension CreateJourneyVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueID.unwindToTripJourneyVC {
            let tripJourneyVC = segue.destination as? TripJourneyVC
            let editedTrip = sender as? Trip
            tripJourneyVC?.editedTrip = editedTrip
            
            // After adding a Journey, we need to refresh the list from previous Controler.
            delegate?.refreshJourneyList()
        }
    }
}

extension CreateJourneyVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResults = searchResults[indexPath.row]
        let cell = journeyTableView.dequeueReusableCell(withIdentifier: Constant.TableViewCells.journeyDestinationCell, for: indexPath)
        
        // We get the address of the journey.
        cell.textLabel?.text = searchResults.title
        cell.detailTextLabel?.text = searchResults.subtitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = journeyTableView.cellForRow(at: indexPath)!
        let firstPartAddress = searchResults[indexPath.row].title
        let secondPartAddress = searchResults[indexPath.row].subtitle
        let completeAddress = firstPartAddress + " " + secondPartAddress
        
        journeySearchBar.text = completeAddress
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
}

extension CreateJourneyVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // We put searchText (our String we need completion for) inside queryFragment for completion.
        searchCompleter.queryFragment = searchText
    }
}

extension CreateJourneyVC: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // searchResults contains the completion results.
        searchResults = completer.results
        
        // If we don't reload the TableView, results won't show up.
        journeyTableView.reloadData()
    }
}

protocol CreateJourneyVCDelegate: AnyObject {
    func refreshJourneyList()
}
