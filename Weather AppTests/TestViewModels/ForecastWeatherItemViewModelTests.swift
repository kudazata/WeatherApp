//
//  ForecastWeatherItemViewModelTests.swift
//  Weather AppTests
//
//  Created by Kuda Zata on 29/11/2022.
//

import XCTest
@testable import Weather_App

class ForecastWeatherItemViewModelTests: XCTestCase {
    
    private var sut: ForecastWeatherItemViewModel!
    private var forecastWeatherItem: ForecastWeatherItem!

    override func setUpWithError() throws {
        let weather = Weather(id: 1, main: "Clouds", description: "", icon: "")
        let main = Main(temp: 25.7, tempMin: 23.2, tempMax: 26.9)
        let date = Date(timeIntervalSince1970: 1669721064)
        forecastWeatherItem = ForecastWeatherItem(main: main, weather: [weather], dtTxt: date)
        sut = ForecastWeatherItemViewModel(forecastWeatherItem)
    }
    
    func testDay_ShouldReturnCorrectDay() {
        XCTAssertEqual(sut.day, "Tuesday")
    }
    
    func testTemperature_ShouldReturnCorrectString() {
        XCTAssertEqual(sut.temperature, "26°")
    }
    
    func testConditionImageName_ShouldReturnCorrectName() {
        XCTAssertEqual(sut.conditionImageName(), "partlysunny")
    }

    override func tearDownWithError() throws {
        sut = nil
        forecastWeatherItem = nil
    }

}
