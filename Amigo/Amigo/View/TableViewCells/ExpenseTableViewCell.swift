//
//  ExpenseTableViewCell.swift
//  Amigo
//
//  Created by Mickaël Horn on 11/05/2023.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {
    
    // MARK: - VIEW LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        setupInterface()
        disableVoiceOverForCell()
    }
    
    // MARK: - OUTLETS
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    
    // MARK: - FUNCTIONS
    func configureCell(date: Date, title: String, amount: Double) {
        dateLabel.text = date.dateToString()
        titleLabel.text = title
        amountLabel.text = String(amount)
        setupVoiceOver()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func disableVoiceOverForCell() {
        // Not allowing accessibility for the cell itself
        isAccessibilityElement = false
        
        // But we enable it for every items in the cell
        accessibilityElements = [dateLabel!, titleLabel!, dateView!, amountLabel!]
    }
    
    private func setupInterface() {
        dateView.layer.borderWidth = 1
        dateView.layer.borderColor = UIColor(named: "UIElement1")?.cgColor
        dateView.layer.cornerRadius = 10
    }
    
    private func setupVoiceOver() {
        // Labels
        dateLabel.accessibilityLabel = "Date of the expense."
        titleLabel.accessibilityLabel = "Expense's name."
        amountLabel.accessibilityLabel = "Expense's amount."
        
        // Values
        dateLabel.accessibilityValue = dateLabel.text
        titleLabel.accessibilityValue = titleLabel.text
        amountLabel.accessibilityValue = amountLabel.text
    }
}
