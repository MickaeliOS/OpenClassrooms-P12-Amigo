//
//  ExpensesVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 11/05/2023.
//

import UIKit

class ExpensesVC: UIViewController {
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupCell()
        fetchExpensesFlow()
        setupVoiceOver()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var expenseTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var addExpenseItemButton: UIButton!
    @IBOutlet weak var expensesTableView: UITableView!
    @IBOutlet weak var saveExpensesButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var expenseDatePicker: UIDatePicker!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var noExpensesLabel: UILabel!
    @IBOutlet weak var savingButtonAI: UIActivityIndicatorView!
    @IBOutlet weak var fetchingAI: UIActivityIndicatorView!
    
    var trip: Trip?
    weak var delegate: ExpensesVCDelegate?
    private let expenseFetchingService = ExpenseFetchingService()
    private let expenseUpdateService = ExpenseUpdateService()
    
    // MARK: - ACTIONS
    @IBAction func addExpenseItemButtonTapped(_ sender: Any) {
        addExpenseItemToList()
    }
    
    @IBAction func saveExpensesButtonTapped(_ sender: Any) {
        saveExpenses()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        expenseTextField.resignFirstResponder()
        amountTextField.resignFirstResponder()
    }
    
    @IBAction func expenseDatePickerTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        addExpenseItemButton.layer.cornerRadius = 10
        saveExpensesButton.layer.cornerRadius = 10
        
        guard let pencilImage = UIImage(systemName: "pencil"),
              let dollarSignImage = UIImage(systemName: "dollarsign.circle") else {
            return
        }
        
        expenseTextField.addLeftSystemImage(image: pencilImage)
        amountTextField.addLeftSystemImage(image: dollarSignImage)
    }
    
    private func setupCell() {
        self.expensesTableView.register(UINib(nibName: Constant.TableViewCells.expenseNibName, bundle: nil),
                                        forCellReuseIdentifier: Constant.TableViewCells.expenseCell)
    }
    
    private func addExpenseItemToList() {
        if trip == nil { return }
        
        guard !expenseTextField.isEmpty, !amountTextField.isEmpty else {
            errorMessageLabel.displayErrorMessage(message: "Both fields must be filled.")
            return
        }
        
        guard let amount = Double(amountTextField.text!) else {
            errorMessageLabel.displayErrorMessage(message: "Please provide a correct amount.")
            return
        }
        
        let expenseItem = ExpenseItem(title: expenseTextField.text!, amount: amount, date: expenseDatePicker.date)
        
        // I am implementing this because if the Trip does not have expenses, so expenses property is nil,
        // the user won't be able to add expenseItems.
        if trip?.expenses == nil { trip?.expenses = Expense() }
        
        if trip?.expenses?.expenseItems == nil {
            trip?.expenses?.expenseItems = [expenseItem]
        } else {
            trip?.expenses?.expenseItems?.append(expenseItem)
        }
        
        // Sorting the expenses by date ascending.
        let dateOrderedExpenses = ExpenseManagement.sortExpensesByDateAscending(expenseItems: trip!.expenses!.expenseItems!)
        trip?.expenses!.expenseItems = dateOrderedExpenses
        
        // Refreshing interface.
        refreshTotalAmount()
        clearTextFields()
        showNoExpensesLabelIfNoExpenses()
        expensesTableView.reloadData()
    }
    
    private func fetchExpensesFlow() {
        guard let expenses = trip?.expenses else {
            fetchExpenses()
            return
        }
        
        if let expenseItems = expenses.expenseItems {
            // Sorting the dates from oldest to newest.
            let dateOrderedExpenses = ExpenseManagement.sortExpensesByDateAscending(expenseItems: expenseItems)
            trip?.expenses?.expenseItems = dateOrderedExpenses
            
            refreshTotalAmount()
        }
        
        showNoExpensesLabelIfNoExpenses()
        expensesTableView.reloadData()
        fetchingAI.isHidden = true
    }
    
    private func fetchExpenses() {
        guard let tripID = trip?.tripID else { return }
        
        expenseFetchingService.fetchTripExpenses(tripID: tripID) { [weak self] expenses, error in
            if let error = error {
                self?.fetchingAI.isHidden = true
                self?.presentErrorAlert(with: error.localizedDescription)
                return
            }
            
            if var expenses = expenses, let expenseItems = expenses.expenseItems {
                if !expenseItems.isEmpty {
                    // Sorting the dates from oldest to newest.
                    let dateOrderedExpenses = ExpenseManagement.sortExpensesByDateAscending(expenseItems: expenseItems)
                    expenses.expenseItems = dateOrderedExpenses
                    
                    // Displaying the expenses.
                    self?.refreshTotalAmount()
                }
                
                // Saving the expenses.
                self?.trip?.expenses = expenses
                self?.delegate?.sendExpenses(expenses: expenses)
                self?.expensesTableView.reloadData()
            }
            
            self?.fetchingAI.isHidden = true
            self?.showNoExpensesLabelIfNoExpenses()
        }
    }
    
    private func saveExpenses() {
        guard let tripID = trip?.tripID, let expenses = trip?.expenses else {
            presentErrorAlert(with: Errors.DatabaseError.nothingToAdd.localizedDescription)
            return
        }
        
        do {
            UIViewController.toggleActivityIndicator(shown: true, button: saveExpensesButton, activityIndicator: savingButtonAI)
            
            // Saving in Firestore.
            try expenseUpdateService.updateExpense(expenses: expenses, for: tripID)
            
            // Sending the modifications.
            delegate?.sendExpenses(expenses: expenses)
            
            // Save completed, we can go back to TripDetailVC.
            presentInformationAlert(with: "Your expenses has been saved.") {
                self.navigationController?.popViewController(animated: true)
            }
            
        } catch let error as Errors.DatabaseError {
            presentErrorAlert(with: error.localizedDescription)
            UIViewController.toggleActivityIndicator(shown: true, button: saveExpensesButton, activityIndicator: savingButtonAI)
        } catch {
            presentErrorAlert(with: Errors.CommonError.defaultError.localizedDescription)
            UIViewController.toggleActivityIndicator(shown: true, button: saveExpensesButton, activityIndicator: savingButtonAI)
        }
    }
    
    private func refreshTotalAmount() {
        guard let expenses = trip?.expenses, let expenseItems = expenses.expenseItems else {
            return
        }
        
        totalLabel.text = "Total: \(ExpenseManagement.getTotalAmount(expenses: expenseItems))"
    }
    
    private func clearTextFields() {
        expenseTextField.text = ""
        amountTextField.text = ""
        expenseTextField.resignFirstResponder()
        amountTextField.resignFirstResponder()
    }
    
    private func setupVoiceOver() {
        // Labels
        amountTextField.accessibilityLabel = "Your amount here."
        expenseDatePicker.accessibilityLabel = "The date of the expense."
        
        // Values
        expenseDatePicker.accessibilityValue = expenseDatePicker.date.dateToString()
        
        // Hints
        addExpenseItemButton.accessibilityHint = "Press to add your expense."
        saveExpensesButton.accessibilityHint = "Press to save your expense."
    }
    
    private func showNoExpensesLabelIfNoExpenses() {
        if trip?.expenses == nil || trip?.expenses?.expenseItems?.isEmpty == true {
            noExpensesLabel.isHidden = false
            return
        }
        noExpensesLabel.isHidden = true
    }
}

// MARK: - EXTENSIONS & PROTOCOLS
extension ExpensesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trip?.expenses?.expenseItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableViewCells.expenseCell) as? ExpenseTableViewCell else {
            return UITableViewCell()
        }
        
        guard let expenseItems = trip?.expenses?.expenseItems else {
            return UITableViewCell()
        }
        
        let expense = expenseItems[indexPath.row]
        
        cell.configureCell(date: expense.date, title: expense.title, amount: expense.amount)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            trip?.expenses?.expenseItems?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // After deletion, it is necessary to check if the list is empty and obtain the new total amount.
            showNoExpensesLabelIfNoExpenses()
            refreshTotalAmount()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(120)
    }
}

extension ExpensesVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        errorMessageLabel.isHidden = true
    }
}

protocol ExpensesVCDelegate: AnyObject {
    func sendExpenses(expenses: Expense)
}
