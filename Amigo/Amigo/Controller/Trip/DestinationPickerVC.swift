//
//  DestinationPickerVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 24/04/2023.
//

import UIKit
import MapKit

class DestinationPickerVC: UIViewController {
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapKitAutocompletion()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.destinationPickerVCDidDismiss()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var countrySearchBar: UISearchBar!
    @IBOutlet weak var locationTableView: UITableView!
    
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResult = [MKLocalSearchCompletion]()
    weak var delegate: DestinationPickerVCDelegate?
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupMapKitAutocompletion() {
        searchCompleter.delegate = self
    }
}

// MARK: - EXTENSIONS & PROTOCOL
extension DestinationPickerVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToCreateTripVC" {
            let createTripVC = segue.destination as? CreateTripVC
            let countryName = sender as? (String, String)
            createTripVC?.destinationAddress = countryName
        }
    }
}

extension DestinationPickerVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResult[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let firstPartAddress = searchResult[indexPath.row].title
        let secondPartAddress = searchResult[indexPath.row].subtitle

        performSegue(withIdentifier: "unwindToCreateTripVC", sender: (firstPartAddress, secondPartAddress))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
}

extension DestinationPickerVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
}

extension DestinationPickerVC: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResult = completer.results
        locationTableView.reloadData()
    }
}

protocol DestinationPickerVCDelegate: AnyObject {
    func destinationPickerVCDidDismiss()
}
