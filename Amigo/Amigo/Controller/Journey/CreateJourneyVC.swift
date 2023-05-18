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
        setupVoiceOver()
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
    @IBOutlet weak var errorMessageLabel: UILabel!
    
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
    
    @IBAction func startDatePickerTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func endDatePickerTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        journeySearchBar.becomeFirstResponder()
        addJourneyButton.layer.cornerRadius = 10
        
        guard let trip = trip else { return }
        
        // We restrict the date range within the scope of the trip.
        startDatePicker.minimumDate = trip.startDate
        startDatePicker.maximumDate = trip.endDate
        endDatePicker.minimumDate = trip.startDate
        endDatePicker.maximumDate = trip.endDate
    }
    
    private func setupMapKitAutocompletion() {
        guard let trip = trip else { return }
        
        searchCompleter.delegate = self
        searchCompleter.resultTypes = [.address, .pointOfInterest]
        
        LocationManagement.filterLocationByRegion(region: trip.country, completion: { [weak self] region in
            guard let region = region else { return }
            self?.searchCompleter.region = region
        })
    }
    
    private func saveJourney() {
        guard let completeAddress = journeySearchBar.text, !completeAddress.isEmpty else {
            errorMessageLabel.isHidden = false
            errorMessageLabel.displayErrorMessage(message: "Please choose at least one destination.")
            return
        }
        
        guard startDatePicker.date <= endDatePicker.date else {
            errorMessageLabel.isHidden = false
            errorMessageLabel.displayErrorMessage(message: "Please select a correct interval of dates.")
            return
        }
        
        // Address decomposition is required for proper storage.
        MKLocalSearch.getPartsFromAddress(address: completeAddress) { [weak self] result, error in
            guard error == nil, let result = result else {
                return
            }
            
            let location = Location(address: result.placemark.name ?? "N/A",
                                    postalCode: result.placemark.postalCode ?? "N/A",
                                    city: result.placemark.locality ?? "N/A",
                                    startDate: (self?.startDatePicker.date)!,
                                    endDate: (self?.endDatePicker.date)!)
            
            self?.addJourney(location: location)
            
            // We empty our interface.
            self?.journeySearchBar.text = ""
            self?.errorMessageLabel.isHidden = true
            self?.journeySearchBar.placeholder = "Another one ?"
            self?.emptyTableView()
        }
    }
    
    private func addJourney(location: Location) {
        guard let journey = journey, journey.locations != nil else {
            self.journey = Journey(locations: [location])
            return
        }
        
        self.journey?.locations?.append(location)
    }
    
    
    private func prepareForRefreshJourney() {
        // Prior to passing the updated journey to JourneyVC, I ensure it is ordered chronologically by date.
        if var journey = self.journey, let locations = journey.locations {
            let orderedJourney = LocationManagement.sortLocationsByDateAscending(locations: locations)
            journey.locations = orderedJourney
            self.journey = journey
        }
        
        performSegue(withIdentifier: Constant.SegueID.unwindToTripJourneyVC, sender: journey)
    }
    
    private func emptyTableView() {
        searchResults.removeAll()
        journeyTableView.reloadData()
    }
    
    private func setupVoiceOver() {
        // Labels
        startDatePicker.accessibilityLabel = "Destination's start date."
        endDatePicker.accessibilityLabel = "Destination's end date."
        
        // Values
        startDatePicker.accessibilityValue = startDatePicker.date.dateToString()
        endDatePicker.accessibilityValue = endDatePicker.date.dateToString()
        
        // Hints
        addJourneyButton.accessibilityHint = "Press to add your destination."
    }
}

// MARK: - EXTENSIONS & PROTOCOLS
extension CreateJourneyVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueID.unwindToTripJourneyVC {
            let tripJourneyVC = segue.destination as? JourneyVC
            let journey = sender as? Journey
            tripJourneyVC?.journey = journey
            
            // After adding a Journey, we need to refresh the list in the previous controller.
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
        let cell = journeyTableView.dequeueReusableCell(withIdentifier: Constant.TableViewCells.journeyLocationCell, for: indexPath)
        
        // We get the address of the journey.
        cell.textLabel?.text = searchResults.title
        cell.detailTextLabel?.text = searchResults.subtitle
        
        // As an exception, I have placed the accessibility hint here because I am unable to do so within the setupVoiceOver() function.
        // This is due to the inability to establish a connection between the table view cell and the view controller.
        cell.accessibilityHint = "Press the row to select your destination."
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // When the user selects an address, the searchBar is automatically populated.
        let firstPartAddress = searchResults[indexPath.row].title
        let secondPartAddress = searchResults[indexPath.row].subtitle
        let completeAddress = firstPartAddress + ", " + secondPartAddress
        
        journeySearchBar.text = completeAddress
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
}

extension CreateJourneyVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            emptyTableView()
            return
        }
        
        errorMessageLabel.isHidden = true
        
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
