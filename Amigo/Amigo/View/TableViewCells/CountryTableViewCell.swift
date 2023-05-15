//
//  CountryTableViewCell.swift
//  Amigo
//
//  Created by Mickaël Horn on 15/05/2023.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    // MARK: - OUTLETS
    @IBOutlet weak var countryFlag: UILabel!
    @IBOutlet weak var countryName: UILabel!
    
    // MARK: - FUNCTIONS
    func configureCell(flag: String, country: String) {
        countryFlag.text = flag
        countryName.text = country
    }
}
