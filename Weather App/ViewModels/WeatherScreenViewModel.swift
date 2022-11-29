//
//  WeatherScreenViewModel.swift
//  Weather App
//
//  Created by Kuda Zata on 28/11/2022.
//

import Foundation
import CoreLocation
import UIKit

protocol WeatherDelegate {
    func didFetchWeatherInfo()
    func errorFetchingWeatherInfo(error: NetworkError)
}

class WeatherScreenViewModel {
    
    var delegate: WeatherDelegate?
    var webService: WebServiceProtocol?
    private var currentWeather: CurrentWeatherResponse?
    private var forecastWeather = [ForecastWeatherItem]()
    
    /// Dispatch group for the multiple network calls for fetching properties in House object
    private var dispatchGroup = DispatchGroup()
    
    var currentTemperature: String {
        if let currentWeather = currentWeather {
            return currentWeather.main.temp.toStringWithZeroDecimalPlaces() + "°"
        }
        else {
            return "--"
        }
    }
    
    var minimumTemperature: String {
        if let currentWeather = currentWeather {
            return currentWeather.main.tempMin.toStringWithZeroDecimalPlaces() + "°"
        }
        else {
            return "--"
        }
    }
    
    var maximumTemperature: String {
        if let currentWeather = currentWeather {
            return currentWeather.main.tempMax.toStringWithZeroDecimalPlaces() + "°"
        }
        else {
            return "--"
        }
    }
        
    func currentCondition() -> String {
        if let currentWeather = currentWeather, let condition = CurrentCondition(rawValue: currentWeather.weather.main) {
            return condition.displayName
        }
        else {
            return "--"
        }
    }
    
    func backgroundImageName() -> String {
        if let currentWeather = currentWeather, let condition = CurrentCondition(rawValue: currentWeather.weather.main) {
            return condition.backgroundImageName
        }
        else {
            return "forest_sunny"
        }
    }
    
    func backgroundColor() -> UIColor {
        if let currentWeather = currentWeather, let condition = CurrentCondition(rawValue: currentWeather.weather.main) {
            return condition.backgroundColor
        }
        else {
            return UIColor(rgb: 0x47AB2F)
        }
    }
    
    
    //MARK: - Tableview properties
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return forecastWeather.count
    }
    
    func forecastWeatherAtIndex(_ index: Int) -> ForecastWeatherItemViewModel {
        let forecastWeatherItem = forecastWeather[index]
        return ForecastWeatherItemViewModel(forecastWeatherItem)
    }
    
    
    //MARK: - Network functions
    func getWeatherInfo(location: CLLocationCoordinate2D) {
        
        getCurrentWeather(location: location)
        getForecastWeather(location: location)
        
        self.dispatchGroup.notify(queue: .main) {
            if self.currentWeather != nil, self.forecastWeather.count > 0 {
                self.delegate?.didFetchWeatherInfo()
            }
        }
    }
    
    private func getCurrentWeather(location: CLLocationCoordinate2D) {
        self.dispatchGroup.enter()
        webService?.getCurrentWeather(location: location) { result in
            switch result {
            case let .success(currentWeatherResponse):
                self.currentWeather = currentWeatherResponse
            case let .failure(error):
                self.delegate?.errorFetchingWeatherInfo(error: error)
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func getForecastWeather(location: CLLocationCoordinate2D) {
        self.dispatchGroup.enter()
        webService?.getForecastWeather(location: location) { result in
            switch result {
            case let .success(forecastWeatherResponse):
                if let response = forecastWeatherResponse {
                    self.forecastWeather = response.list
                }
            case let .failure(error):
                self.delegate?.errorFetchingWeatherInfo(error: error)
            }
            self.dispatchGroup.leave()
        }
    }
    
}

struct ForecastWeatherItemViewModel {
    
    init(_ forecastWeatherItem: ForecastWeatherItem) {
        self.forecastWeatherItem = forecastWeatherItem
    }
    
    private var forecastWeatherItem: ForecastWeatherItem
    
    var day: String {
        return "Monday"
    }
    
    var temperature: String {
        return forecastWeatherItem.main.temp.toStringWithZeroDecimalPlaces() + "°"
    }
    
    func conditionImageName() -> String {
        if let condition = CurrentCondition(rawValue: forecastWeatherItem.weather.main) {
            return condition.imageName
        }
        else {
            return "clear"
        }
    }
    
}

enum CurrentCondition: String {
    case cloudy = "Clouds"
    case rainy = "Rain"
    case clear = "Clear"
    
    var displayName: String {
        switch self {
        case .cloudy:
            return "Cloudy"
        case .rainy:
            return "Rainy"
        case .clear:
            return "Sunny"
        }
    }
    
    var imageName: String {
        switch self {
        case .cloudy:
            return "partlysunny"
        case .rainy:
            return "rain"
        case .clear:
            return "clear"
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .clear:
            return UIColor(rgb: 0x47AB2F)
        case .rainy:
            return UIColor(rgb: 0x57575D)
        case .cloudy:
            return UIColor(rgb: 0x54717A)
        }
    }
    
    var backgroundImageName: String {
        switch self {
        case .cloudy:
            return "forest_cloudy"
        case .rainy:
            return "forest_rainy"
        case .clear:
            return "forest_sunny"
        }
    }
}
