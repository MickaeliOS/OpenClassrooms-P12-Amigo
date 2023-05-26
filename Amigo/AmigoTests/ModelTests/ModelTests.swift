//
//  ModelTests.swift
//  AmigoTests
//
//  Created by Mickaël Horn on 22/05/2023.
//

import XCTest
import MapKit
@testable import Amigo

final class ModelTests: XCTestCase {
    
    // MARK: - UTILITIES FUNC
    private func setupExpenses() -> [ExpenseItem] {
        // Creating samples expense items.
        let expenseItem1 = ExpenseItem(title: "Expense1", amount: 100, date: Date().addingTimeInterval(3600))
        let expenseItem2 = ExpenseItem(title: "Expense2", amount: 10, date: Date().addingTimeInterval(7200))
        let expenseItem3 = ExpenseItem(title: "Expense3", amount: 25.60, date: Date().addingTimeInterval(1800))
        
        return [expenseItem1, expenseItem2, expenseItem3]
    }
    
    // MARK: - User.swift
    func testGivenWomanGender_WhenGettingIndexOfGender_ThenReturnWomanIndex() {
        let gender = User.Gender.woman
        let indexOfGender = User.Gender.index(of: gender)
        XCTAssertEqual(indexOfGender, 0)
    }

    func testGivenManGender_WhenGettingIndexOfGender_ThenReturnManIndex() {
        let gender = User.Gender.man
        let indexOfGender = User.Gender.index(of: gender)
        XCTAssertEqual(indexOfGender, 1)
    }
    
    // MARK: - UserManagement.swift
    func testGivenIncorrectEMail_WhenControllingTheEMail_ThenReturnFalse() {
        XCTAssertFalse(UserManagement.isValidEmail("invalidmail"))
    }
    
    func testGivenCorrectEMail_WhenControllingTheEMail_ThenReturnTrue() {
        XCTAssertTrue(UserManagement.isValidEmail("validmail@test.com"))
    }
    
    func testGivenIncorrectPassword_WhenControllingThePassword_ThenReturnFalse() {
        XCTAssertFalse(UserManagement.isValidPassword("123456"))
    }
    
    func testGivenCorrectPassword_WhenControllingThePassword_ThenReturnTrue() {
        XCTAssertTrue(UserManagement.isValidPassword("lkioKp9"))
    }
    
    func testGivenDifferentPasswords_WhenEqualityCheck_ThenPasswordsAreDifferents() {
        let password = "juh7j"
        let confirmPassword = "ijrge"
        let equalityResult = UserManagement.passwordEqualityCheck(password: password, confirmPassword: confirmPassword)
        
        XCTAssertFalse(equalityResult)
    }
    
    func testGivenSamePasswords_WhenEqualityCheck_ThenPasswordsAreEquals() {
        let password = "juh7j"
        let confirmPassword = "juh7j"
        let equalityResult = UserManagement.passwordEqualityCheck(password: password, confirmPassword: confirmPassword)
        
        XCTAssertTrue(equalityResult)
    }
    
    // MARK: - TripManagement.swift
    func testGivenTripTable_WhenSortingByDates_ThenTripTableIsSorted() {
        // Creating samples trips.
        let trip1 = Trip(tripID: "1", userID: "user1", startDate: Date(), endDate: Date().addingTimeInterval(3600), country: "France", countryCode: "FR")
        let trip2 = Trip(tripID: "2", userID: "user2", startDate: Date(), endDate: Date().addingTimeInterval(7200), country: "Monaco", countryCode: "MC")
        let trip3 = Trip(tripID: "3", userID: "user3", startDate: Date(), endDate: Date().addingTimeInterval(1800), country: "Egypt", countryCode: "EG")
        
        let unsortedTrips: [Trip] = [trip1, trip2, trip3]
        let sortedTrips = TripManagement.sortTripsByDateAscending(trips: unsortedTrips)
        
        // Validating the correct ordering of the sorted trips.
        XCTAssertEqual(sortedTrips[0].country, "Egypt")
        XCTAssertEqual(sortedTrips[1].country, "France")
        XCTAssertEqual(sortedTrips[2].country, "Monaco")
    }
    
    // MARK: - ExpenseManagement.swift
    func testGivenExpenseTable_WhenSortingByDates_ThenExpenseTableIsSorted() {
        let unsortedExpenseItems = setupExpenses()
        let sortedExpenses = ExpenseManagement.sortExpensesByDateAscending(expenseItems: unsortedExpenseItems)
        
        // Validating the correct ordering of the sorted expense items.
        XCTAssertEqual(sortedExpenses[0].title, "Expense3")
        XCTAssertEqual(sortedExpenses[1].title, "Expense1")
        XCTAssertEqual(sortedExpenses[2].title, "Expense2")
    }
    
    func testGivenEmptyExpenseTable_WhenCalculatingTheTotalAmount_ThenTotalAmountIsCalculated() {
        let expenseItems = setupExpenses()
        let totalAmount = ExpenseManagement.getTotalAmount(expenses: expenseItems)
        XCTAssertEqual(totalAmount, 135.6)
    }
    
    func testGivenEmptyExpenseTable_WhenCalculatingTheTotalAmount_ThenTotalAmountIs0() {
        let totalAmount = ExpenseManagement.getTotalAmount(expenses: [])
        XCTAssertEqual(totalAmount, 0.0)
    }
    
    // MARK: - LocationManagement.swift
    func testGivenLocationTable_WhenSortingByDates_ThenLocationTableIsSorted() {
        // Creating samples locations.
        let location1 = Location(address: "Address 1", postalCode: "11111", city: "City 1", startDate: Date(), endDate: Date().addingTimeInterval(3600))
        let location2 = Location(address: "Address 2", postalCode: "22222", city: "City 2", startDate: Date(), endDate: Date().addingTimeInterval(7200))
        let location3 = Location(address: "Address 3", postalCode: "33333", city: "City 3", startDate: Date(), endDate: Date().addingTimeInterval(1800))
        
        let unsortedLocations: [Location] = [location1, location2, location3]
        let sortedLocations = LocationManagement.sortLocationsByDateAscending(locations: unsortedLocations)
        
        // Validating the correct ordering of the sorted locations.
        XCTAssertEqual(sortedLocations[0].city, "City 3")
        XCTAssertEqual(sortedLocations[1].city, "City 1")
        XCTAssertEqual(sortedLocations[2].city, "City 2")
    }
    
    func testGivenAValidRegion_WhenAskingForCoordinates_ThenCoordinatesReturns() {
        let expectation = XCTestExpectation(description: "Completion called")
        
        LocationManagement().getCoordinatesFromRegion(region: "France") { coordinateRegion, error in
            XCTAssertNil(error)
            
            // Checking if we got the good coordinates.
            XCTAssertEqual(coordinateRegion?.center.latitude, 46.26319925)
            XCTAssertEqual(coordinateRegion?.center.longitude, 2.1886005)
            XCTAssertEqual(coordinateRegion?.span.latitudeDelta, 7.452321918635983)
            XCTAssertEqual(coordinateRegion?.span.longitudeDelta, 10.744818517368163)

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testGivenAnInvalidRegion_WhenAskingForCoordinates_ThenCoordinatesReturnsNil() {
        let expectation = XCTestExpectation(description: "Completion called")
        
        // Using a Mock to test the case where there is no errors, but the result is nil.
        let locationManagement = LocationManagement(geocoder: CLGeocoderMock())
        
        locationManagement.getCoordinatesFromRegion(region: "Region") { coordinateRegion, error in
            XCTAssertNil(coordinateRegion)
            XCTAssertNil(error)

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGivenAnInvalidRegion_WhenAskingForCoordinates_ThenCoordinatesReturnsError() {
        let expectation = XCTestExpectation(description: "Completion called")
        
        LocationManagement().getCoordinatesFromRegion(region: "InvalidRegionName") { coordinateRegion, error in
            XCTAssertNotNil(error)
            XCTAssertTrue(error is Errors.CommonError)
            XCTAssertNil(coordinateRegion)

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    // MARK: - ModelExtensions.swift
    func testGivenADate_WhenConverting_ThenDateIsConvertedToString() {
        let date = Date(timeIntervalSince1970: 1684826138)
        let convertedDate = date.dateToString()
        XCTAssertEqual(convertedDate, "May 23, 2023")
    }
    
    func testGivenAnAddress_WhenGettingPartOfTheAddress_ThenWeHaveAddressParts() {
        let address = "12 Rue Volney, 75002 Paris, France"
        let expectation = expectation(description: "Search expectation")

        
        MKLocalSearch.getPartsFromAddress(address: address) { mkMapItem, error in
            XCTAssertNil(error)
            XCTAssertNotNil(mkMapItem)
            
            // We make sure every part of the address is good.
            XCTAssertEqual(mkMapItem?.placemark.country, "France")
            XCTAssertEqual(mkMapItem?.placemark.name, "12 Rue Volney")
            XCTAssertEqual(mkMapItem?.placemark.postalCode, "75002")
            XCTAssertEqual(mkMapItem?.placemark.locality, "Paris")

            expectation.fulfill()

        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testGivenIncorrectAddress_WhenGettingPartOfTheAddress_ThenErrorOccur() {
        let address = " "
        let expectation = expectation(description: "Search expectation")

        MKLocalSearch.getPartsFromAddress(address: address) { mkMapItem, error in
            XCTAssertNotNil(error)
            XCTAssertTrue(error is Errors.CommonError)
            XCTAssertNil(mkMapItem)

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGivenFranceCountryCode_WhenGettingTheFlag_ThenWeGetFranceFlag() {
        let countryCode = "FR"
        let expectedFlag = "🇫🇷"
        
        let flag = String.countryFlag(countryCode: countryCode)
        XCTAssertEqual(flag, expectedFlag)
    }
    
    func testGivenIncorrectCountryCode_WhenGettingTheFlag_ThenNilReturns() {
        let countryCode = "IncorrectCode"
        
        let flag = String.countryFlag(countryCode: countryCode)
        XCTAssertNil(flag)
    }

    func testGivenCountryListProperty_WhenGettingCountryList_ThenCountryListIsReturned() {
        let countryList = Locale.countryList
        
        // Due to the extensive length of the list, I will not be testing each individual country.
        // However, I make sure the list contains 256 countries, which is the complete list.
        XCTAssertTrue(countryList.contains("France"))
        XCTAssertTrue(countryList.contains("Japan"))
        XCTAssertTrue(countryList.contains("Monaco"))
        XCTAssertTrue(countryList.contains("Morocco"))
        XCTAssertEqual(countryList.count, 256)
    }
    
    func testGivenContryName_WhenGettingCountryCode_ThenCountryCodeReturns() {
        let countryName = "France"
        
        let countryCode = Locale.countryCode(forCountryName: countryName)
        
        XCTAssertEqual(countryCode, "FR")
    }
    
    func testGivenInvalidContryName_WhenGettingCountryCode_ThenCountryCodeReturnsNil() {
        let countryName = "InvalidCountryName"
        
        let countryCode = Locale.countryCode(forCountryName: countryName)
        
        XCTAssertNil(countryCode)
    }
}
