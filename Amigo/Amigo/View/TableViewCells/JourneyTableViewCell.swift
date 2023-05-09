//
//  JourneyTableViewCell.swift
//  Amigo
//
//  Created by Mickaël Horn on 08/05/2023.
//

import UIKit

class JourneyTableViewCell: UITableViewCell {

    // MARK: - VIEW LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var arrowDateImage: UIImageView!
    
    // MARK: - FUNCTIONS
    func configureCell(startDate: String, endDate: String, destination: String) {
        startDateLabel.text = startDate
        endDateLabel.text = endDate
        destinationLabel.text = destination
    }
}
