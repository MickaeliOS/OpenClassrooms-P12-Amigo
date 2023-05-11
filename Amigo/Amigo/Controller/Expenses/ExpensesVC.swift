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
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var expenseTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var addExpenseButton: UIButton!
    @IBOutlet weak var expensesTableView: UITableView!
    @IBOutlet weak var saveExpensesButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var expenseDatePicker: UIDatePicker!
    @IBOutlet weak var totalLabel: UILabel!
    
    var trip: Trip?
    weak var delegate: ExpensesVCDelegate?
    private var userAuth = UserAuth.shared
    private let tripUpdateService = TripUpdateService()

    // MARK: - ACTIONS
    @IBAction func addExpensesButtonTapped(_ sender: Any) {
        addExpenseToList()
    }
    
    @IBAction func saveExpensesButtonTapped(_ sender: Any) {
        guard let tripID = trip?.tripID, let expenses = trip?.expenses else {
            return
        }
        
        Task {
            do {
                try await tripUpdateService.updateTrip(with: tripID, fields: [Constant.FirestoreTables.Trip.expenses: expenses])
                
                if let index = userAuth.user?.trips?.firstIndex(where: {$0.tripID == tripID}) {
                    
                    // Second step -> By storing the list in the Singleton, we ensure that the data remains consistent both locally and remotely.
                    userAuth.user?.trips?[index].expenses = expenses
                    
                    // Third step -> It's also essential to update the trip variable and propagate the changes to the TripDetailVC, to maintain synchronization across all data points.
                    sendTripToPresentingController()
                    navigationController?.popViewController(animated: true)
                }
                
            } catch let error as Errors.DatabaseError {
                presentErrorAlert(with: error.localizedDescription)
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        expenseTextField.resignFirstResponder()
        amountTextField.resignFirstResponder()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        addExpenseButton.layer.cornerRadius = 10
        saveExpensesButton.layer.cornerRadius = 10
    }
    
    private func setupCell() {
        self.expensesTableView.register(UINib(nibName: Constant.TableViewCells.expenseNibName, bundle: nil),
                                    forCellReuseIdentifier: Constant.TableViewCells.expenseCell)
    }
    
    private func addExpenseToList() {
        guard !expenseTextField.isEmpty, !amountTextField.isEmpty else {
            errorMessageLabel.displayErrorMessage(message: "Both fields must be filled.")
            return
        }
        
        guard let amount = Double(amountTextField.text!) else {
            errorMessageLabel.displayErrorMessage(message: "Please provide a correct amount.")
            return
        }
        
        let expense = Expense(title: expenseTextField.text!, amount: amount, date: expenseDatePicker.date)
        
        if trip?.expenses == nil {
            var expenses = [Expense]()
            expenses.append(expense)
            trip?.expenses = expenses
        } else {
            trip?.expenses?.append(expense)
        }
        
        expensesTableView.reloadData()
    }
    
    private func sendTripToPresentingController() {
        guard let trip = trip else { return }
        
        // We need to communicate eventuals changes.
        delegate?.getTripFromExpensesVC(trip: trip)
    }
}

// MARK: - EXTENSIONS
extension ExpensesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trip?.expenses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableViewCells.expenseCell) as? ExpenseTableViewCell else {
            return UITableViewCell()
        }
        
        guard let expenses = trip?.expenses else {
            return UITableViewCell()
        }
                         
        let expense = expenses[indexPath.row]
        
        cell.configureCell(date: expense.date, title: expense.title, amount: expense.amount)
                 
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
}

extension ExpensesVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

protocol ExpensesVCDelegate: AnyObject {
    func getTripFromExpensesVC(trip: Trip)
}
