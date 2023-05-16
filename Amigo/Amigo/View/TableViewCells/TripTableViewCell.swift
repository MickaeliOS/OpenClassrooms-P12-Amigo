//
//  TripTableViewCell.swift
//  Amigo
//
//  Created by Mickaël Horn on 01/05/2023.
//

import UIKit

class TripTableViewCell: UITableViewCell {
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var flagIconLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var findTripImage: UIImageView!
    
    // MARK: - FUNCTIONS
    func configureCell(country: String, countryCode: String, fromDate: Date, toDate: Date) {
        // I retrieve the country's flag to display it.
        flagIconLabel.text = String.countryFlag(countryCode: countryCode)
        
        destinationLabel.text = country
        self.startDate.text = "From: \(fromDate.dateToString())"
        self.endDate.text = "To: \(toDate.dateToString())"
    }
}
