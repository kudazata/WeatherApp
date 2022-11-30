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
    
    /// Dispatch group for the multiple network calls for fetching current and forecast weather
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
    func getWeatherInfoByCoordinates(latitude: Double, longitude: Double) {
        
        getCurrentWeatherByCoordinates(latitude: latitude, longitude: longitude)
        getForecastWeatherByCoordinates(latitude: latitude, longitude: latitude)
        
        self.dispatchGroup.notify(queue: .main) {
            if self.currentWeather != nil, self.forecastWeather.count > 0 {
                self.saveCurrentCity(cityName: self.currentWeather?.name ?? "")
                self.delegate?.didFetchWeatherInfo()
            }
        }
    }
    
    func getWeatherInfoByCity(cityName: String) {
        
        getCurrentWeatherByCity(cityName: cityName)
        getForecastWeatherByCity(cityName: cityName)
        
        self.dispatchGroup.notify(queue: .main) {
            if self.currentWeather != nil, self.forecastWeather.count > 0 {
                self.delegate?.didFetchWeatherInfo()
            }
        }
    }
    
    private func getCurrentWeatherByCity(cityName: String) {
        self.dispatchGroup.enter()
        webService?.getCurrentWeather(latitude: nil, longitude: nil, cityName: cityName) { result in
            switch result {
            case let .success(currentWeatherResponse):
                self.currentWeather = currentWeatherResponse
            case let .failure(error):
                self.delegate?.errorFetchingWeatherInfo(error: error)
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func getForecastWeatherByCity(cityName: String) {
        self.dispatchGroup.enter()
        webService?.getForecastWeather(latitude: nil, longitude: nil, cityName: cityName) { result in
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
    
    private func getCurrentWeatherByCoordinates(latitude: Double, longitude: Double) {
        self.dispatchGroup.enter()
        webService?.getCurrentWeather(latitude: latitude, longitude: longitude, cityName: nil) { result in
            switch result {
            case let .success(currentWeatherResponse):
                self.currentWeather = currentWeatherResponse
            case let .failure(error):
                self.delegate?.errorFetchingWeatherInfo(error: error)
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func getForecastWeatherByCoordinates(latitude: Double, longitude: Double) {
        self.dispatchGroup.enter()
        webService?.getForecastWeather(latitude: latitude, longitude: longitude, cityName: nil) { result in
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
    
    private func saveCurrentCity(cityName: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(cityName, forKey: "currentCity")
    }
    
    func clearCurrentData() {
        currentWeather = nil
        forecastWeather = [ForecastWeatherItem]()
    }
    
}
