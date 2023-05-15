//
//  ExpenseTableViewCell.swift
//  Amigo
//
//  Created by Mickaël Horn on 11/05/2023.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - OUTLETS
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    // MARK: - FUNCTIONS
    func configureCell(date: Date, title: String, amount: Double) {
        dateLabel.text = date.dateToString()
        titleLabel.text = title
        amountLabel.text = String(amount)
    }
}
