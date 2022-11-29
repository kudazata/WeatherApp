//
//  ForecastWeatherResponse.swift
//  Weather App
//
//  Created by Kuda Zata on 28/11/2022.
//

import Foundation

struct ForecastWeatherResponse: Decodable {
    var list: [ForecastWeatherItem]
}

struct ForecastWeatherItem: Decodable {
    var main: Main
    var weather: [Weather]
    var dtTxt: Date
}
