//
//  WebServiceMock.swift
//  Weather AppTests
//
//  Created by Kuda Zata on 28/11/2022.
//

import Foundation
import CoreLocation
@testable import Weather_App

struct WebServiceMock: WebServiceProtocol {
    
    let weather = Weather(id: 1, main: "Clouds", description: "", icon: "")
    let main = Main(temp: 25.7, tempMin: 23.2, tempMax: 26.9)
    let date = Date()
    
    func getCurrentWeather(latitude: Double?, longitude: Double?, cityName: String?, completion: @escaping (Result<CurrentWeatherResponse?, NetworkError>) -> Void) {
        
        let currentWeatherResponse = CurrentWeatherResponse(name: "Harare", weather: [weather], main: main)
        completion(.success(currentWeatherResponse))
    }
    
    func getForecastWeather(latitude: Double?, longitude: Double?, cityName: String?, completion: @escaping (Result<ForecastWeatherResponse?, NetworkError>) -> Void) {
        
        let forecastWeatherItem = ForecastWeatherItem(main: main, weather: [weather], dtTxt: date)
        let forecastWeatherResponse = ForecastWeatherResponse(list: [forecastWeatherItem, forecastWeatherItem, forecastWeatherItem, forecastWeatherItem, forecastWeatherItem])
        
        completion(.success(forecastWeatherResponse))
    }
    
}
