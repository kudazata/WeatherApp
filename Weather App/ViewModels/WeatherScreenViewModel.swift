//
//  WeatherScreenViewModel.swift
//  Weather App
//
//  Created by Kuda Zata on 28/11/2022.
//

import Foundation

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
    
    var cityName: String {
        if let currentWeather = currentWeather {
            return currentWeather.name
        }
        else {
            return "--"
        }
    }
    
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
        if let currentWeather = currentWeather, let condition = CurrentCondition(rawValue: currentWeather.weather[0].main) {
            return condition.displayName
        }
        else {
            return "--"
        }
    }
    
    func backgroundImageName() -> String {
        if let currentWeather = currentWeather, let condition = CurrentCondition(rawValue: currentWeather.weather[0].main) {
            return condition.backgroundImageName
        }
        else {
            return "forest_sunny"
        }
    }
    
    func backgroundColorHexValue() -> Int {
        if let currentWeather = currentWeather, let condition = CurrentCondition(rawValue: currentWeather.weather[0].main) {
            return condition.backgroundColorHexValue
        }
        else {
            return 0x47AB2F
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
    func getWeatherInfo(latitude: Double, longitude: Double) {
        
        getCurrentWeather(latitude: latitude, longitude: longitude)
        getForecastWeather(latitude: latitude, longitude: latitude)
        
        self.dispatchGroup.notify(queue: .main) {
            if self.currentWeather != nil, self.forecastWeather.count > 0 {
                self.delegate?.didFetchWeatherInfo()
            }
        }
    }
    
    private func getCurrentWeather(latitude: Double, longitude: Double) {
        self.dispatchGroup.enter()
        webService?.getCurrentWeather(latitude: latitude, longitude: longitude) { result in
            switch result {
            case let .success(currentWeatherResponse):
                self.currentWeather = currentWeatherResponse
            case let .failure(error):
                self.delegate?.errorFetchingWeatherInfo(error: error)
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func getForecastWeather(latitude: Double, longitude: Double) {
        self.dispatchGroup.enter()
        webService?.getForecastWeather(latitude: latitude, longitude: longitude) { result in
            switch result {
            case let .success(forecastWeatherResponse):
                if let response = forecastWeatherResponse {
                    let indexSet: IndexSet = self.createIndexSet(numberOfItems: response.list.count)
                    self.forecastWeather = indexSet.map { response.list[$0] }
                }
            case let .failure(error):
                self.delegate?.errorFetchingWeatherInfo(error: error)
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func createIndexSet(numberOfItems: Int) -> IndexSet {
        let step = (numberOfItems) / 5
        var value = step
        var array = [Int]()
        
        for _ in 0..<5 {
            array.append(value-1)
            value = value + step
        }
        
        return IndexSet(array)
    }
    
}
