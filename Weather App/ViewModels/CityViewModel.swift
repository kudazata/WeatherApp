//
//  CityViewModel.swift
//  Weather App
//
//  Created by Kuda Zata on 29/11/2022.
//

import Foundation

struct CityViewModel {
    
    private(set) var cityName: String
    private(set) var isCurrentCity: Bool
    
    init(_ city: String, isCurrentCity: Bool) {
        self.cityName = city
        self.isCurrentCity = isCurrentCity
    }
    
}
