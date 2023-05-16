//
//  CountryTableViewCell.swift
//  Amigo
//
//  Created by Mickaël Horn on 15/05/2023.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    // MARK: - VIEW LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        setupVoiceOver()
    }
    
    // MARK: - OUTLETS
    @IBOutlet weak var countryFlag: UILabel!
    @IBOutlet weak var countryName: UILabel!
    
    // MARK: - FUNCTIONS
    func configureCell(flag: String, country: String) {
        countryFlag.text = flag
        countryName.text = country
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupVoiceOver() {
        accessibilityHint = "Press the row to select your country."
    }
}
