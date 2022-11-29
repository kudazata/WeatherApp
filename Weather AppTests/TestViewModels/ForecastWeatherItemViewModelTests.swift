//
//  ForecastWeatherItemViewModelTests.swift
//  Weather AppTests
//
//  Created by Kuda Zata on 29/11/2022.
//

import XCTest
@testable import Weather_App

class ForecastWeatherItemViewModelTests: XCTestCase {
    
    private var viewModel: ForecastWeatherItemViewModel!
    private var forecastWeatherItem: ForecastWeatherItem!

    override func setUpWithError() throws {
        let weather = Weather(id: 1, main: "Clouds", description: "", icon: "")
        let main = Main(temp: 25.7, tempMin: 23.2, tempMax: 26.9)
        let date = Date(timeIntervalSince1970: 1669721064)
        forecastWeatherItem = ForecastWeatherItem(main: main, weather: [weather], dtTxt: date)
        viewModel = ForecastWeatherItemViewModel(forecastWeatherItem)
    }
    
    func testDay_ShouldReturnCorrectDay() {
        XCTAssertEqual(viewModel.day, "Tuesday")
    }
    
    func testTemperature_ShouldReturnCorrectString() {
        XCTAssertEqual(viewModel.temperature, "26°")
    }
    
    func testConditionImageName_ShouldReturnCorrectName() {
        XCTAssertEqual(viewModel.conditionImageName(), "partlysunny")
    }

    override func tearDownWithError() throws {
        viewModel = nil
        forecastWeatherItem = nil
    }

}
