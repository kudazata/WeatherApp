//
//  Constants.swift
//  Weather App
//
//  Created by Kuda Zata on 28/11/2022.
//

import Foundation
import CoreLocation

struct Urls {
    
    /// This function generates and return a url string for pagination purpopes
    /// - Parameter pageNumber: pagination page number
    /// - Returns: url string
    static func currentWeatherUrl(latitude: Double, longitude: Double) -> String {
        return "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=d23516d0b2787144caf23421d5ec4515&units=metric"
    }
    
    static func forecastWeather(latitude: Double, longitude: Double) -> String {
        return "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=d23516d0b2787144caf23421d5ec4515&units=metric"
    }
    
}
