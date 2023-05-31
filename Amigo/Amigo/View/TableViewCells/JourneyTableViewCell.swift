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
        disableVoiceOverForCell()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var arrowDateImage: UIImageView!
    @IBOutlet weak var datesView: UIView!
    
    // MARK: - FUNCTIONS
    func configureCell(startDate: String, endDate: String, destination: String) {
        startDateLabel.text = startDate
        endDateLabel.text = endDate
        destinationLabel.text = destination
        setupVoiceOver()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func disableVoiceOverForCell() {
        // Not allowing accessibility for the cell itself
        isAccessibilityElement = false
        
        // But we enable it for every items in the cell
        accessibilityElements = [startDateLabel!, endDateLabel!, destinationLabel!, datesView!]
    }
    
    private func setupVoiceOver() {
        // Labels
        startDateLabel.accessibilityLabel = "Start date."
        endDateLabel.accessibilityLabel = "End date."
        destinationLabel.accessibilityLabel = "Destination."
        
        // Values
        startDateLabel.accessibilityValue = startDateLabel.text
        endDateLabel.accessibilityValue = endDateLabel.text
        destinationLabel.accessibilityValue = destinationLabel.text
    }
}
