//
//  ExpenseFirestoreTests.swift
//  AmigoTests
//
//  Created by Mickaël Horn on 29/05/2023.
//

import XCTest
@testable import Amigo

final class ExpenseFirestoreTests: XCTestCase {

    // MARK: - MOCK AND MODEL
    private var firebaseMock: FirebaseMock!
    private var expenseUpdateService: ExpenseUpdateService!
    private var expenseFetchingService: ExpenseFetchingService!
    private var expenseDeletionService: ExpenseDeletionService!
    
    // MARK: - UTILITIES FUNC
    override func setUp() {
        super.setUp()
        firebaseMock = FirebaseMock()
        expenseUpdateService = ExpenseUpdateService(firebaseWrapper: firebaseMock)
        expenseFetchingService = ExpenseFetchingService(firebaseWrapper: firebaseMock)
        expenseDeletionService = ExpenseDeletionService(firebaseWrapper: firebaseMock)
    }
    
    // MARK: - updateExpense TESTS
    func testGivenAnError_WhenUpdatingExpense_ThenCannotUpdateDocumentsError() {
        firebaseMock.success = false
        
        XCTAssertThrowsError(try expenseUpdateService.updateExpense(expenses: Expense(), for: "1234")) { error in
            guard let databaseError = error as? Errors.DatabaseError else {
                XCTFail("Test failed, expected to be Errors.DatabaseError type.")
                return
            }
            
            XCTAssertTrue(firebaseMock.updateExpenseTriggered)
            XCTAssertEqual(databaseError, .cannotUpdateDocuments)
            XCTAssertEqual(databaseError.localizedDescription, "We couldn't update your document(s), please try again.")
        }
    }
    
    func testGivenNoError_WhenUpdatingExpense_ThenExpenseIsUpdated() {
        XCTAssertNoThrow(try expenseUpdateService.updateExpense(expenses: Expense(), for: "1234"))
        XCTAssertTrue(firebaseMock.updateExpenseTriggered)
    }
    
    // MARK: - fetchTripExpenses TESTS
    func testGivenAnError_WhenFetchingExpense_ThenCannotGetDocumentsError() {
        firebaseMock.fetchTripExpensesError = firebaseMock.testError
        
        expenseFetchingService.fetchTripExpenses(tripID: "1234") { expense, error in
            XCTAssertTrue(self.firebaseMock.fetchTripExpensesTriggered)
            XCTAssertNotNil(error)
            XCTAssertEqual(error, .cannotGetDocuments)
            XCTAssertEqual(error?.localizedDescription, "We couldn't retrieve your document(s), please try to log in again.")
        }
    }
    
    func testGivenNoError_WhenFetchingExpense_ThenExpenseIsFetched() {        
        expenseFetchingService.fetchTripExpenses(tripID: "1234") { expense, error in
            guard let expense = expense else {
                XCTFail("Test failed, expense should not be nil.")
                return
            }
            
            XCTAssertTrue(self.firebaseMock.fetchTripExpensesTriggered)
            XCTAssertNil(error)
            XCTAssertEqual(expense.expenseItems?[0].title, "Pizza")
            XCTAssertEqual(expense.expenseItems?[0].amount, 12)
            XCTAssertEqual(expense.expenseItems?[0].date, Date(timeIntervalSince1970: 1685359786))

        }
    }
    
    // MARK: - fetchTripExpenses TESTS
    func testGivenAnError_WhenDeletingExpense_ThenCannotDeleteDocumentsError() async {
        firebaseMock.success = false
        
        do {
            try await expenseDeletionService.deleteExpense(tripID: "1234")
            XCTFail("Test failed, expected to throw but passed.")

        } catch let error as Errors.DatabaseError {
            XCTAssertTrue(firebaseMock.deleteExpenseTriggered)
            XCTAssertEqual(error, .cannotDeleteDocuments)
            XCTAssertEqual(error.localizedDescription, "We couldn't delete your document(s), please try again.")
        } catch {
            XCTFail("Test failed, expected to be Errors.DatabaseError type.")
        }
    }
    
    func testGivenNoError_WhenDeletingExpense_ThenExpenseIsDeleted() async {
        do {
            try await expenseDeletionService.deleteExpense(tripID: "1234")
            XCTAssertTrue(firebaseMock.deleteExpenseTriggered)

        } catch {
            XCTFail("Test failed, was not expected to throw.")
        }
    }
}
