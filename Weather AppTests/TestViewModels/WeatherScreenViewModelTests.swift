//
//  WeatherScreenViewModelTests.swift
//  Weather AppTests
//
//  Created by Kuda Zata on 28/11/2022.
//

import XCTest
@testable import Weather_App

class WeatherScreenViewModelTests: XCTestCase {

    private var viewModel: WeatherScreenViewModel!
    private var webServiceMock: WebServiceProtocol!
    private var latitude: Double!
    private var longitude: Double!
    
    override func setUpWithError() throws {
        viewModel = WeatherScreenViewModel()
        webServiceMock = WebServiceMock()
        viewModel.webService = webServiceMock
        latitude = -17.7730237
        longitude = 30.9954091
    }
    
    func testCurrentTemperatureStringWhenNoDataHasBeenFetched_ShouldReturnDashes() {
        XCTAssertEqual(viewModel.currentTemperature, "--")
    }
    
    func testMaximumTemperatureStringWhenNoDataHasBeenFetched_ShouldReturnDashes() {
        XCTAssertEqual(viewModel.maximumTemperature, "--")
    }
    
    func testMinimumTemperatureStringWhenNoDataHasBeenFetched_ShouldReturnDashes() {
        XCTAssertEqual(viewModel.minimumTemperature, "--")
    }
    
    func testCurrentConditionStringWhenNoDataHasBeenFetched_ShouldReturnDashes() {
        XCTAssertEqual(viewModel.currentCondition(), "--")
    }
    
    func testBackgroundImageNameWhenNoDataHasBeenFetched_ShouldReturnForestSunny() {
        XCTAssertEqual(viewModel.backgroundImageName(), "forest_sunny")
    }
    
    func testBackgroundColorWhenNoDataHasBeenFetched_ShouldReturnHexValue() {
        XCTAssertEqual(viewModel.backgroundColorHexValue(), 0x47AB2F)
    }
    

    func testNumberOfSections_ShouldReturnOne() {
        XCTAssertEqual(viewModel.numberOfSections, 1)
    }
    
    func testNumberOfRowsInSectionWhenNoDataHasBeenFetched_ShouldReturnZero() {
        XCTAssertEqual(viewModel.numberOfRowsInSection(0), 0)
    }
    
    func testCurrentTemperatureWhenDataHasBeenFetched_ShouldReturnCorrectString() {
        viewModel.getWeatherInfo(latitude: latitude, longitude: longitude)
        XCTAssertEqual(viewModel.currentTemperature, "26°")
    }
    
    func testMaximumTemperatureWhenDataHasBeenFetched_ShouldReturnCorrectString() {
        viewModel.getWeatherInfo(latitude: latitude, longitude: longitude)
        XCTAssertEqual(viewModel.maximumTemperature, "27°")
    }
    
    func testMinimumTemperatureWhenDataHasBeenFetched_ShouldReturnCorrectString() {
        viewModel.getWeatherInfo(latitude: latitude, longitude: longitude)
        XCTAssertEqual(viewModel.minimumTemperature, "23°")
    }
    
    func testCurrentConditionWhenDataHasBeenFetched_ShouldReturnCorrectString() {
        viewModel.getWeatherInfo(latitude: latitude, longitude: longitude)
        XCTAssertEqual(viewModel.currentCondition(), "Cloudy")
    }
    
    func testBackgroundImageNameWhenDataHasBeenFetched_ShouldReturnCorrectString() {
        viewModel.getWeatherInfo(latitude: latitude, longitude: longitude)
        XCTAssertEqual(viewModel.backgroundImageName(), "forest_cloudy")
    }
    
    func testBackgroundColorWhenDataHasBeenFetched_ShouldReturnCorrectHexValue() {
        viewModel.getWeatherInfo(latitude: latitude, longitude: longitude)
        XCTAssertEqual(viewModel.backgroundColorHexValue(), 0x54717A)
    }
    
    func testNumberOfRowsInSectionWhenDataHasBeenFetched_ShouldReturnFive() {
        viewModel.getWeatherInfo(latitude: latitude, longitude: longitude)
        XCTAssertEqual(viewModel.numberOfRowsInSection(0), 5)
    }
    
    func testForecastWeatherAtIndex_ShouldReturnForecastWeatherItemViewModel() {
        viewModel.getWeatherInfo(latitude: latitude, longitude: longitude)
        let weather = Weather(id: 1, main: "Clouds", description: "", icon: "")
        let main = Main(temp: 25.7, tempMin: 23.2, tempMax: 26.9)
        let date = Date()
        let forecastWeatherItem = ForecastWeatherItem(main: main, weather: [weather], dtTxt: date)
        let forecastWeatherItemViewModel = ForecastWeatherItemViewModel(forecastWeatherItem)
        
        XCTAssertEqual(viewModel.forecastWeatherAtIndex(1).day, forecastWeatherItemViewModel.day)
        XCTAssertEqual(viewModel.forecastWeatherAtIndex(1).temperature, forecastWeatherItemViewModel.temperature)
        XCTAssertEqual(viewModel.forecastWeatherAtIndex(1).conditionImageName(), forecastWeatherItemViewModel.conditionImageName())
    }

    override func tearDownWithError() throws {
        viewModel = nil
        webServiceMock = nil
        latitude = nil
        longitude = nil
    }

}
