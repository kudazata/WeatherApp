//
//  WeatherScreenViewController.swift
//  Weather App
//
//  Created by Kuda Zata on 25/11/2022.
//

import UIKit

class WeatherScreenViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var largeCurrentTemperatureLabel: UILabel!
    @IBOutlet weak var currentConditionLabel: UILabel!
    @IBOutlet weak var minimumTemperatureLabel: UILabel!
    @IBOutlet weak var smallCurrentTemperatureLabel: UILabel!
    @IBOutlet weak var maximumTemperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension WeatherScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell")!
        return cell
    }
    
    
}
