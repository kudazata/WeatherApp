//
//  CityTableViewCell.swift
//  Weather App
//
//  Created by Kuda Zata on 29/11/2022.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentLocationImage: UIImageView!
    
    func configureCell(viewModel: CityViewModel) {
        cityNameLabel.text = viewModel.cityName
        currentLocationImage.isHidden = !viewModel.isCurrentCity
    }
}
