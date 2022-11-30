//
//  ForecastTableViewCellTests.swift
//  Weather AppTests
//
//  Created by Kuda Zata on 30/11/2022.
//

import XCTest
@testable import Weather_App

class ForecastTableViewCellTests: XCTestCase {
    
    private var sut: ForecastTableViewCell!
    private var tableView: UITableView!

    override func setUpWithError() throws {
        
        let weather = Weather(id: 1, main: "Clouds", description: "", icon: "")
        let main = Main(temp: 25.7, tempMin: 23.2, tempMax: 26.9)
        let date = Date(timeIntervalSince1970: 1669721064)
        let forecastWeatherItem = ForecastWeatherItem(main: main, weather: [weather], dtTxt: date)
        let viewModel = ForecastWeatherItemViewModel(forecastWeatherItem)
        
        let weatherScreenVC = UIStoryboard(name: "WeatherScreen", bundle: nil).instantiateViewController(withIdentifier: "weatherScreen") as! WeatherScreenViewController
        _ = weatherScreenVC.view
        
        sut = weatherScreenVC.tableView.dequeueReusableCell(withIdentifier: "forecastCell") as? ForecastTableViewCell
        
        sut.configureCell(viewModel: viewModel)
    }
    
    func testCell_ShouldPopulateCorrectly() {
        XCTAssertEqual(sut.dayLabel.text, "Tuesday")
        XCTAssertEqual(sut.temperatureLabel.text, "26°")
        XCTAssertEqual(sut.conditionImage.image, UIImage(named: "partlysunny"))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


}
