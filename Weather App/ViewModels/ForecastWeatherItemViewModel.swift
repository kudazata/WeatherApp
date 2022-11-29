//
//  ForecastWeatherItemViewModel.swift
//  Weather App
//
//  Created by Kuda Zata on 29/11/2022.
//

import Foundation

struct ForecastWeatherItemViewModel {
    
    init(_ forecastWeatherItem: ForecastWeatherItem) {
        self.forecastWeatherItem = forecastWeatherItem
    }
    
    private var forecastWeatherItem: ForecastWeatherItem
    
    var day: String {
        return forecastWeatherItem.dtTxt.dayOfWeek()!
    }
    
    var temperature: String {
        return forecastWeatherItem.main.temp.toStringWithZeroDecimalPlaces() + "°"
    }
    
    func conditionImageName() -> String {
        if let condition = CurrentCondition(rawValue: forecastWeatherItem.weather[0].main) {
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
    
    var backgroundColorHexValue: Int {
        switch self {
        case .clear:
            return 0x47AB2F
        case .rainy:
            return 0x57575D
        case .cloudy:
            return 0x54717A
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
