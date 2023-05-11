//
//  Expense.swift
//  Amigo
//
//  Created by Mickaël Horn on 11/05/2023.
//

import Foundation

struct Expense: Codable {
    var title: String
    var amount: Double
    var date: Date
}
