//
//  CitiesViewModelTests.swift
//  Weather AppTests
//
//  Created by Kuda Zata on 30/11/2022.
//

import XCTest
@testable import Weather_App

class CitiesViewModelTests: XCTestCase {
    
    private var sut: CitiesViewModel!
    private var webServiceMock: WebServiceProtocol!
    private var city: String!
    private var userDefaults: UserDefaults!

    override func setUpWithError() throws {
        sut = CitiesViewModel()
        webServiceMock = WebServiceMock()
        sut.webService = webServiceMock
        userDefaults = UserDefaults.standard
        city = "Harare"
    }
    
    func testSearchCity_ShouldSaveCity() {
        sut.searchCity(city)
        let cities = userDefaults.stringArray(forKey: "cities") ?? []
        XCTAssertTrue(cities.contains(city))
    }
    
    func testRemoveCityAtIndex_ShouldRemoveCity() {
        let citiesArray = ["Harare", "Pretoria", "Johannesburg"]
        userDefaults.set(citiesArray, forKey: "cities")
        sut.removeCityAtIndex(0)
        let cities = userDefaults.stringArray(forKey: "cities") ?? []
        XCTAssertEqual(cities, ["Pretoria", "Johannesburg"])
    }
    
    func testGetCities_ShouldPopulateCitiesInViewModel() {
        let citiesArray = ["Harare", "Pretoria", "Johannesburg"]
        userDefaults.set(citiesArray, forKey: "cities")
        sut.getCities()
        XCTAssertEqual(sut.cityAtIndex(0).cityName, "Harare")
    }
    
    func testNumberOfSections_ShouldReturnTwo() {
        XCTAssertEqual(sut.numberOfSections, 2)
    }
    
    func testNumberOfRowsInFirstSection_ShouldReturnOne() {
        XCTAssertEqual(sut.numberOfRowsInSection(0), 1)
    }
    
    func testNumberOfRowsInSecondSection_ShouldReturnCitiesCount() {
        let citiesArray = ["Harare", "Pretoria", "Johannesburg"]
        userDefaults.set(citiesArray, forKey: "cities")
        sut.getCities()
        XCTAssertEqual(sut.numberOfRowsInSection(1), 3)
    }

    func testGetCurrentCity_ShouldReturnCorrectCity() {
        userDefaults.set("Harare", forKey: "currentCity")
        XCTAssertEqual(sut.getCurrentCity().cityName, "Harare")
    }
    
    override func tearDownWithError() throws {
        sut = nil
        webServiceMock = nil
        city = nil
        userDefaults.removeObject(forKey: "cities")
        userDefaults = nil
    }


}
