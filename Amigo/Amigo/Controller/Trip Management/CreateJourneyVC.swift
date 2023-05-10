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
        setupInterface()
        setupMapKitAutocompletion()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        prepareForRefreshJourney()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var journeySearchBar: UISearchBar!
    @IBOutlet weak var journeyTableView: UITableView!
    @IBOutlet weak var addJourneyButton: UIButton!
    
    var trip: Trip?
    var journey: Journey?
    weak var delegate: CreateJourneyVCDelegate?
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    
    // MARK: - ACTIONS
    @IBAction func addJourneyTapped(_ sender: Any) {
        saveJourney()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func setupInterface() {
        guard let trip = trip else { return }
        
        // We restrict the date range within the scope of the trip.
        startDatePicker.minimumDate = trip.startDate
        startDatePicker.maximumDate = trip.endDate
        endDatePicker.minimumDate = trip.startDate
        endDatePicker.maximumDate = trip.endDate
        
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
            
            let location = Location(address: result.placemark.name ?? "N/A",
                                    postalCode: result.placemark.postalCode ?? "N/A",
                                    city: result.placemark.locality ?? "N/A",
                                    startDate: (self?.startDatePicker.date)!,
                                    endDate: (self?.endDatePicker.date)!)
            
            if self?.journey?.locations == nil {
                var locations = [Location]()
                locations.append(location)
                self?.journey?.locations = locations
            } else {
                self?.journey?.locations?.append(location)
            }
            
            // We empty our interface.
            self?.journeySearchBar.text = ""
            self?.searchResults.removeAll()
            self?.journeyTableView.reloadData()
        }
    }
    
    private func prepareForRefreshJourney() {
        if var journey = self.journey, let locations = journey.locations {
            let orderedJourney = LocationManagement.sortLocationsByDateAscending(locations: locations)
            journey.locations = orderedJourney
            self.journey = journey
        }
        performSegue(withIdentifier: Constant.SegueID.unwindToTripJourneyVC, sender: journey)
    }
}

// MARK: - EXTENSIONS & PROTOCOLS
extension CreateJourneyVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueID.unwindToTripJourneyVC {
            let tripJourneyVC = segue.destination as? JourneyVC
            let journey = sender as? Journey
            tripJourneyVC?.journey = journey
            
            // After adding a Journey, we need to refresh the list from previous Controler.
            delegate?.refreshJourney()
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
    func refreshJourney()
}
