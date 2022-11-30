//
//  CitiesViewController.swift
//  Weather App
//
//  Created by Kuda Zata on 29/11/2022.
//

import UIKit

class CitiesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel = CitiesViewModel()
    var backgroundColorHex: Int!
    var webService: WebServiceProtocol = WebService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.getCities()
        viewModel.webService = webService
        createAddButton()
        self.view.backgroundColor = UIColor(rgb: backgroundColorHex)
    }
    
    @objc func addNewCity(){
        showAddNewCityAlert()
    }
    
    private func createAddButton() {
        let addButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addNewCity))
        addButton.tintColor = .white
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    private func showAddNewCityAlert() {
        showAlertWithTextField(title: "Add city", message: "Please enter the full name of the city you wish to add", placeholder: "City name", vc: self) { cityName in
            self.viewModel.searchCity(cityName)
        }
    }
}

extension CitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell") as? CityTableViewCell {
            if indexPath.section == 0 {
                let cityVM = viewModel.getCurrentCity()
                cell.configureCell(viewModel: cityVM)
                return cell
            }
            else {
                let cityVM = viewModel.cityAtIndex(indexPath.row)
                cell.configureCell(viewModel: cityVM)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityName = indexPath.section == 0 ? viewModel.getCurrentCity().cityName : viewModel.cityAtIndex(indexPath.row).cityName
        if let presentingVC = self.presentingViewController as? WeatherScreenViewController {
            presentingVC.updateCity(cityName: cityName)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeCityAtIndex(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 0 {
            return .none
        } else {
            return.delete
        }
    }
}

extension CitiesViewController: CitiesDelegate {
    
    func didSaveCity() {
        self.tableView.reloadData()
    }
    
    func didGetCities() {
        self.tableView.reloadData()
    }
    
    func errorFindingCity() {
        showRetryAlert(title: "City not found", message: "This city could not be found. Please verify the spelling and try again", vc: self) {
            self.showAddNewCityAlert()
        }
    }
    
    func cityExists() {
        showGeneralAlert(title: "City exists", message: "This city is already saved", vc: self)
    }
}
