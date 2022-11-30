//
//  CitiesViewControllerTests.swift
//  Weather AppTests
//
//  Created by Kuda Zata on 30/11/2022.
//

import XCTest
@testable import Weather_App

class CitiesViewControllerTests: XCTestCase {
    
    private var sut: CitiesViewController!
    private var webServiceMock = WebServiceMock()

    override func setUpWithError() throws {
        sut = UIStoryboard(name: "Cities", bundle: nil).instantiateViewController(withIdentifier: "citiesVC") as? CitiesViewController
        sut.webService = webServiceMock
        sut.backgroundColorHex = 0x47AB2F
        _ = sut.view
    }
    
    func testTableViewNumberOfSections_ShouldReturnTwo() {
        XCTAssertEqual(sut.tableView.numberOfSections, 2)
    }
    
    func testTableViewNumberOfRows_ShouldReturnCorrectNumber() {
        let userDefaults = UserDefaults.standard
        userDefaults.set("Harare", forKey: "currentCity")
        userDefaults.set(["Mutare", "Bulawayo", "Vic Falls"], forKey: "cities")
        sut.viewModel.getCities()
        sut.tableView.reloadData()
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 1), 3)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

}
