//
//  ExpenseManagement.swift
//  Amigo
//
//  Created by Mickaël Horn on 12/05/2023.
//

import Foundation

final class ExpenseManagement {
    static func sortExpensesByDateAscending(expenseItems: [ExpenseItem]) -> [ExpenseItem] {
        var copiedExpenseItems = expenseItems
        copiedExpenseItems.sort(by: { $0.date.compare($1.date) == .orderedAscending })
        return copiedExpenseItems
    }
}
