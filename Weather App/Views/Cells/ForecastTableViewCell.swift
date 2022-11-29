//
//  ForecastTableViewCell.swift
//  Weather App
//
//  Created by Kuda Zata on 25/11/2022.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    func configureCell(viewModel: ForecastWeatherItemViewModel) {
        dayLabel.text = viewModel.day
        conditionImage.image = UIImage(named: viewModel.conditionImageName())
        temperatureLabel.text = viewModel.temperature
    }

}
