//
//  WeatherScreenViewController.swift
//  Weather App
//
//  Created by Kuda Zata on 25/11/2022.
//

import UIKit
import CoreLocation

class WeatherScreenViewController: UIViewController, WeatherDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var largeCurrentTemperatureLabel: UILabel!
    @IBOutlet weak var currentConditionLabel: UILabel!
    @IBOutlet weak var minimumTemperatureLabel: UILabel!
    @IBOutlet weak var smallCurrentTemperatureLabel: UILabel!
    @IBOutlet weak var maximumTemperatureLabel: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    let locationManager = CLLocationManager()
    
    let viewModel = WeatherScreenViewModel()
    var location: CLLocationCoordinate2D!
    var didFetchLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayInfo()
        viewModel.delegate = self
        viewModel.webService = WebService()
        self.locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        location = locationManager.location?.coordinate
        locationManager.delegate = self

    }
    
    private func displayInfo() {
        cityNameLabel.text = viewModel.cityName
        largeCurrentTemperatureLabel.text = viewModel.currentTemperature
        currentConditionLabel.text = viewModel.currentCondition()
        minimumTemperatureLabel.text = viewModel.minimumTemperature
        smallCurrentTemperatureLabel.text = viewModel.currentTemperature
        maximumTemperatureLabel.text = viewModel.maximumTemperature
        backgroundImage.image = UIImage(named: viewModel.backgroundImageName())
        self.view.backgroundColor = UIColor(rgb: viewModel.backgroundColorHexValue())
        tableView.reloadData()
    }
    
    @IBAction func citiesButtonPressed(_ sender: Any) {
        let citiesVC = UIStoryboard(name: "Cities", bundle: nil).instantiateViewController(withIdentifier: "citiesVC") as! CitiesViewController
        let navController = UINavigationController(rootViewController: citiesVC)
        navController.modalPresentationStyle = .fullScreen
        navController.navigationBar.prefersLargeTitles = true
        citiesVC.navigationItem.title = "My cities"
        navController.navigationBar.backgroundColor = .clear
        self.present(navController, animated: true)
    }
    
    func didFetchWeatherInfo() {
        displayInfo()
    }
    
    func errorFetchingWeatherInfo(error: NetworkError) {
        var errorMessage = ""
        
        switch error {
            
        case .customError(let customError):
            errorMessage = customError.localizedDescription
        default:
            errorMessage = error.localizedDescription
        }

        showRetryAlert(title: "Network error", message: errorMessage, vc: self) { [weak self] in
            if let self = self {
                self.viewModel.getWeatherInfo(latitude: self.location.latitude, longitude: self.location.longitude)
            }
        }
    }

}

extension WeatherScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell") as! ForecastTableViewCell
        cell.configureCell(viewModel: viewModel.forecastWeatherAtIndex(indexPath.row))
        return cell
    }
    
}

extension WeatherScreenViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !didFetchLocation {
            self.didFetchLocation = true
            self.location = locations[0].coordinate
            viewModel.getWeatherInfo(latitude: location.latitude, longitude: location.longitude)
        }
    }
}
