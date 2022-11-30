//
//  CitiesViewModel.swift
//  Weather App
//
//  Created by Kuda Zata on 29/11/2022.
//

import Foundation

protocol CitiesDelegate {
    func didSaveCity()
    func didGetCities()
    func errorFindingCity()
    func cityExists()
}

class CitiesViewModel {

    var webService: WebServiceProtocol?
    var delegate: CitiesDelegate?
    private var cities = [String]()
    
    func searchCity(_ city: String) {
        webService?.getCurrentWeather(latitude: nil, longitude: nil, cityName: city, completion: { result in
            switch result {
            case .success(_):
                self.saveCity(city)
            case .failure(_):
                self.delegate?.errorFindingCity()
            }
        })
    }
    
    private func saveCity(_ city: String) {
        let userDefaults = UserDefaults.standard
        var citiesArray: [String] = userDefaults.stringArray(forKey: "cities") ?? []
        if citiesArray.contains(city) {
            delegate?.cityExists()
            return
        }
        citiesArray.append(city)
        userDefaults.set(citiesArray, forKey: "cities")
        self.cities = citiesArray
        delegate?.didSaveCity()
    }
    
    func removeCityAtIndex(_ index: Int) {
        let userDefaults = UserDefaults.standard
        var citiesArray: [String] = userDefaults.stringArray(forKey: "cities") ?? []
        citiesArray.remove(at: index)
        userDefaults.set(citiesArray, forKey: "cities")
        self.cities = citiesArray
    }
    
    func getCities() {
        let userDefaults = UserDefaults.standard
        let citiesArray: [String] = userDefaults.stringArray(forKey: "cities") ?? []
        self.cities = citiesArray
    }
    
    //MARK: - Tableview properties
    
    var numberOfSections: Int {
        return 2
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return cities.count
    }
    
    func cityAtIndex(_ index: Int) -> CityViewModel {
        let city = cities[index]
        return CityViewModel(city, isCurrentCity: false)
    }
    
    func getCurrentCity() -> CityViewModel {
        let userDefaults = UserDefaults.standard
        let city = userDefaults.string(forKey: "currentCity") ?? ""
        return CityViewModel(city, isCurrentCity: true)
    }
    
}
