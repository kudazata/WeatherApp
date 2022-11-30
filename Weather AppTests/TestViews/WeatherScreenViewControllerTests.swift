//
//  WeatherScreenViewControllerTests.swift
//  Weather AppTests
//
//  Created by Kuda Zata on 30/11/2022.
//

import XCTest
@testable import Weather_App

class WeatherScreenViewControllerTests: XCTestCase {
    
    private var sut: WeatherScreenViewController!
    private var webServiceMock = WebServiceMock()
    
    override func setUpWithError() throws {
        sut = UIStoryboard(name: "WeatherScreen", bundle: nil).instantiateViewController(withIdentifier: "weatherScreen") as? WeatherScreenViewController
        sut.webService = webServiceMock
        _ = sut.view
    }

    func testTableViewNumberOfSections_ShouldReturnOne() {
        XCTAssertEqual(sut.tableView.numberOfSections, 1)
    }
    
    func testTableViewNumberOfRows_ShouldReturnCorrectNumber() {
        sut.viewModel.getWeatherInfoByCity(cityName: "Harare")
        sut.tableView.reloadData()
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 5)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }

}
