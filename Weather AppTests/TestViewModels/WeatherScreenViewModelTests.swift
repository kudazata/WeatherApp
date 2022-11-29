//
//  WeatherScreenViewModelTests.swift
//  Weather AppTests
//
//  Created by Kuda Zata on 28/11/2022.
//

import XCTest
@testable import Weather_App

class WeatherScreenViewModelTests: XCTestCase {

    private var sut: WeatherScreenViewModel!
    private var webServiceMock: WebServiceProtocol!
    private var latitude: Double!
    private var longitude: Double!
    
    override func setUpWithError() throws {
        sut = WeatherScreenViewModel()
        webServiceMock = WebServiceMock()
        sut.webService = webServiceMock
        latitude = -17.7730237
        longitude = 30.9954091
    }
    
    func testCurrentTemperatureStringWhenNoDataHasBeenFetched_ShouldReturnDashes() {
        XCTAssertEqual(sut.currentTemperature, "--")
    }
    
    func testMaximumTemperatureStringWhenNoDataHasBeenFetched_ShouldReturnDashes() {
        XCTAssertEqual(sut.maximumTemperature, "--")
    }
    
    func testMinimumTemperatureStringWhenNoDataHasBeenFetched_ShouldReturnDashes() {
        XCTAssertEqual(sut.minimumTemperature, "--")
    }
    
    func testCurrentConditionStringWhenNoDataHasBeenFetched_ShouldReturnDashes() {
        XCTAssertEqual(sut.currentCondition(), "--")
    }
    
    func testBackgroundImageNameWhenNoDataHasBeenFetched_ShouldReturnForestSunny() {
        XCTAssertEqual(sut.backgroundImageName(), "forest_sunny")
    }
    
    func testBackgroundColorWhenNoDataHasBeenFetched_ShouldReturnHexValue() {
        XCTAssertEqual(sut.backgroundColorHexValue(), 0x47AB2F)
    }
    

    func testNumberOfSections_ShouldReturnOne() {
        XCTAssertEqual(sut.numberOfSections, 1)
    }
    
    func testNumberOfRowsInSectionWhenNoDataHasBeenFetched_ShouldReturnZero() {
        XCTAssertEqual(sut.numberOfRowsInSection(0), 0)
    }
    
    func testCurrentTemperatureWhenDataHasBeenFetched_ShouldReturnCorrectString() {
        sut.getWeatherInfo(latitude: latitude, longitude: longitude)
        XCTAssertEqual(sut.currentTemperature, "26°")
    }
    
    func testMaximumTemperatureWhenDataHasBeenFetched_ShouldReturnCorrectString() {
        sut.getWeatherInfo(latitude: latitude, longitude: longitude)
        XCTAssertEqual(sut.maximumTemperature, "27°")
    }
    
    func testMinimumTemperatureWhenDataHasBeenFetched_ShouldReturnCorrectString() {
        sut.getWeatherInfo(latitude: latitude, longitude: longitude)
        XCTAssertEqual(sut.minimumTemperature, "23°")
    }
    
    func testCurrentConditionWhenDataHasBeenFetched_ShouldReturnCorrectString() {
        sut.getWeatherInfo(latitude: latitude, longitude: longitude)
        XCTAssertEqual(sut.currentCondition(), "Cloudy")
    }
    
    func testBackgroundImageNameWhenDataHasBeenFetched_ShouldReturnCorrectString() {
        sut.getWeatherInfo(latitude: latitude, longitude: longitude)
        XCTAssertEqual(sut.backgroundImageName(), "forest_cloudy")
    }
    
    func testBackgroundColorWhenDataHasBeenFetched_ShouldReturnCorrectHexValue() {
        sut.getWeatherInfo(latitude: latitude, longitude: longitude)
        XCTAssertEqual(sut.backgroundColorHexValue(), 0x54717A)
    }
    
    func testNumberOfRowsInSectionWhenDataHasBeenFetched_ShouldReturnFive() {
        sut.getWeatherInfo(latitude: latitude, longitude: longitude)
        XCTAssertEqual(sut.numberOfRowsInSection(0), 5)
    }
    
    func testForecastWeatherAtIndex_ShouldReturnForecastWeatherItemViewModel() {
        sut.getWeatherInfo(latitude: latitude, longitude: longitude)
        let weather = Weather(id: 1, main: "Clouds", description: "", icon: "")
        let main = Main(temp: 25.7, tempMin: 23.2, tempMax: 26.9)
        let date = Date()
        let forecastWeatherItem = ForecastWeatherItem(main: main, weather: [weather], dtTxt: date)
        let forecastWeatherItemViewModel = ForecastWeatherItemViewModel(forecastWeatherItem)
        
        XCTAssertEqual(sut.forecastWeatherAtIndex(1).day, forecastWeatherItemViewModel.day)
        XCTAssertEqual(sut.forecastWeatherAtIndex(1).temperature, forecastWeatherItemViewModel.temperature)
        XCTAssertEqual(sut.forecastWeatherAtIndex(1).conditionImageName(), forecastWeatherItemViewModel.conditionImageName())
    }

    override func tearDownWithError() throws {
        sut = nil
        webServiceMock = nil
        latitude = nil
        longitude = nil
    }

}
