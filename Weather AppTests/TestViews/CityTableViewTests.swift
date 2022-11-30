//
//  CityTableViewTests.swift
//  Weather AppTests
//
//  Created by Kuda Zata on 30/11/2022.
//

import XCTest
@testable import Weather_App

class CityTableViewTests: XCTestCase {
    
    private var sut: CityTableViewCell!

    override func setUpWithError() throws {
        let cityViewModel = CityViewModel("Harare", isCurrentCity: true)
        let citiesVC = UIStoryboard(name: "Cities", bundle: nil).instantiateViewController(withIdentifier: "citiesVC") as! CitiesViewController
        citiesVC.backgroundColorHex = 0x47AB2F
        _ = citiesVC.view
        sut = citiesVC.tableView.dequeueReusableCell(withIdentifier: "cityCell") as? CityTableViewCell
        sut.configureCell(viewModel: cityViewModel)
    }
    
    func testCell_ShouldPopulateCorrectly() {
        XCTAssertEqual(sut.cityNameLabel.text, "Harare")
        XCTAssertFalse(sut.currentLocationImage.isHidden)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

}
