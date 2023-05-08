//
//  CountryPickerVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 24/04/2023.
//

import UIKit

class CountryPickerVC: UIViewController {
    
    // MARK: - VIEW LIFE CYCLE
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

// MARK: - EXTENSIONS & PROTOCOL
extension CountryPickerVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueID.unwindToCreateTripVC {
            let createTripVC = segue.destination as? CreateTripVC
            let countryInformations = sender as? (String, String)
            createTripVC?.countryInformations = countryInformations
        }
    }
}

extension CountryPickerVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableViewCells.countryCell, for: indexPath)
        cell.textLabel?.text = filteredCountryList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let countryName = filteredCountryList[indexPath.row]
        let countryCode = Locale.countryCode(forCountryName: countryName)
        let countryInformations = (countryName, countryCode ?? "N/A")
        
        performSegue(withIdentifier: Constant.SegueID.unwindToCreateTripVC, sender: countryInformations)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
}

extension CountryPickerVC: UISearchBarDelegate {
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
