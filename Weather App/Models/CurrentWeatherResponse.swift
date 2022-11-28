//
//  CurrentWeatherResponse.swift
//  Weather App
//
//  Created by Kuda Zata on 27/11/2022.
//

import Foundation

struct CurrentWeatherResponse: Decodable {
    
    var name: String
    var weather: Weather
    var main: Main
}

struct Weather: Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct Main: Decodable {
    var temp: Double
    var tempMin: Double
    var tempMax: Double
}
