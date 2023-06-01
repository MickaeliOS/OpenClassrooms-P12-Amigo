//
//  CountryPickerVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 24/04/2023.
//

import UIKit
import FirebaseAnalytics

class CountryPickerVC: UIViewController {
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        countrySearchBar.becomeFirstResponder()
        setupCell()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var countrySearchBar: UISearchBar!
    @IBOutlet weak var countryTableView: UITableView!
    
    weak var delegate: CountryPickerVCDelegate?
    private var filteredCountryList = [String]()
    private let countryList = Locale.countryList
    
    // MARK: - ACTIONS
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - FUNCTIONS
    private func setupCell() {
        self.countryTableView.register(UINib(nibName: Constant.TableViewCells.countryNibName, bundle: nil),
                                       forCellReuseIdentifier: Constant.TableViewCells.countryCell)
    }
}

// MARK: - EXTENSIONS & PROTOCOL
extension CountryPickerVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueID.unwindToCreateTripVC {
            let createTripVC = segue.destination as? CreateTripVC
            let countryInformations = sender as? (String, String)
            createTripVC?.countryInformations = countryInformations
            
            // We refresh the countryName in the previous VC.
            delegate?.refreshCountryNameFromPicker()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableViewCells.countryCell, for: indexPath) as? CountryTableViewCell else {
            return UITableViewCell()
        }
        
        // Let's get the country's flag.
        let countryCode = Locale.countryCode(forCountryName: filteredCountryList[indexPath.row])
        let countryFlag = String.countryFlag(countryCode: countryCode ?? "N/A")
        
        // We will present the country name in conjunction with its corresponding national flag.
        cell.configureCell(flag: countryFlag ?? "N/A", country: filteredCountryList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Upon user selection, we pass the country's information to the previous controller that contains the trip creation form.
        let countryName = filteredCountryList[indexPath.row]
        let countryCode = Locale.countryCode(forCountryName: countryName)
        let countryInformations = (countryName, countryCode ?? "N/A")
        
        // A little custom event for Firebase Analytics where we store the picked countries.
        Analytics.logEvent("picked_countries", parameters: [
            "name": countryName
        ])
        
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

protocol CountryPickerVCDelegate: AnyObject {
    func refreshCountryNameFromPicker()
}
