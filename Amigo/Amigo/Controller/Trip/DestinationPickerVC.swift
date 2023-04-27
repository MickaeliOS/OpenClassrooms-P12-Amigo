//
//  DestinationPickerVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 24/04/2023.
//

import UIKit

class DestinationPickerVC: UIViewController {
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.destinationPickerVCDidDismiss()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var countrySearchBar: UISearchBar!
    @IBOutlet weak var countryTableView: UITableView!
    private let countryList = Locale.countryList
    private var filteredCountryList = [String]()
    weak var delegate: DestinationPickerVCDelegate?
}

// MARK: - PRIVATE FUNCTIONS

// MARK: - EXTENSIONS & PROTOCOL
extension DestinationPickerVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToCreateTripVC" {
            let createTripVC = segue.destination as? CreateTripVC
            let countryName = sender as? String
            createTripVC?.countryName = countryName
        }
    }
}

extension DestinationPickerVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        cell.textLabel?.text = filteredCountryList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "unwindToCreateTripVC", sender: filteredCountryList[indexPath.row])
    }
}

extension DestinationPickerVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            filteredCountryList = countryList
            filteredCountryList = countryList.filter({ $0.contains(searchText) })
        } else {
            filteredCountryList = []
        }
        countryTableView.reloadData()
    }
}

protocol DestinationPickerVCDelegate: AnyObject {
    func destinationPickerVCDidDismiss()
}
