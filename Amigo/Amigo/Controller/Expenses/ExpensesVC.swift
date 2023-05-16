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
        fetchExpenses()
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
    
    var trip: Trip?
    weak var delegate: ExpensesVCDelegate?
    private var expenses: Expense?
    private var userAuth = UserAuth.shared
    private let expenseFetchingService = ExpenseFetchingService()
    private let expenseUpdateService = ExpenseUpdateService()

    // MARK: - ACTIONS
    @IBAction func addExpenseItemButtonTapped(_ sender: Any) {
        addExpenseItemToList()
    }
    
    @IBAction func saveExpensesButtonTapped(_ sender: Any) {
        guard let tripID = trip?.tripID, let expenses = expenses else {
            return
        }
    
        do {
            try expenseUpdateService.updateExpense(expenses: expenses, for: tripID)
            presentInformationAlert(with: "Your expenses has been saved.") {
                self.navigationController?.popViewController(animated: true)
            }
            
        } catch let error as Errors.DatabaseError {
            presentErrorAlert(with: error.localizedDescription)
        } catch {
            presentErrorAlert(with: Errors.CommonError.defaultError.localizedDescription)
        }
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
        
        guard let pencilImage = UIImage(systemName: "pencil"), let dollarSignImage = UIImage(systemName: "dollarsign.circle") else {
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
        guard !expenseTextField.isEmpty, !amountTextField.isEmpty else {
            errorMessageLabel.displayErrorMessage(message: "Both fields must be filled.")
            return
        }
        
        guard let amount = Double(amountTextField.text!) else {
            errorMessageLabel.displayErrorMessage(message: "Please provide a correct amount.")
            return
        }
        
        let expenseItem = ExpenseItem(title: expenseTextField.text!, amount: amount, date: expenseDatePicker.date)

        if expenses?.expenseItems == nil {
            expenses?.expenseItems = [expenseItem]
        } else {
            expenses?.expenseItems?.append(expenseItem)
        }

        refreshTotalAmount()
        clearTextFields()
        expensesTableView.reloadData()
    }

    private func fetchExpenses() {
        guard let tripID = trip?.tripID else { return }

        expenseFetchingService.fetchTripExpenses(tripID: tripID) { [weak self] expenses, error in
            if let error = error {
                self?.presentErrorAlert(with: error.localizedDescription)
                return
            }
            
            if var expenses = expenses, let expenseItems = expenses.expenseItems {
                // Sorting the dates from oldes to newest.
                let dateOrderedExpenses = ExpenseManagement.sortExpensesByDateAscending(expenseItems: expenseItems)
                expenses.expenseItems = dateOrderedExpenses
                
                // Since we have the journey data available, we can display it in the TableView.
                self?.expenses = expenses
                self?.refreshTotalAmount()
                self?.expensesTableView.reloadData()
                return
            }
            
            // I am implementing this because if the Trip does not have expenses, so expenses property is nil,
            // the user won't be able to add expenseItems.
            self?.expenses = Expense()
        }
    }
    
    private func refreshTotalAmount() {
        guard let expenses = expenses, let expenseItems = expenses.expenseItems else {
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
}

// MARK: - EXTENSIONS
extension ExpensesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses?.expenseItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableViewCells.expenseCell) as? ExpenseTableViewCell else {
            return UITableViewCell()
        }
        
        guard let expenseItems = expenses?.expenseItems else {
            return UITableViewCell()
        }
                         
        let expense = expenseItems[indexPath.row]
        
        cell.configureCell(date: expense.date, title: expense.title, amount: expense.amount)
                 
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            expenses?.expenseItems?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
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
    func getTripFromExpensesVC(trip: Trip)
}
