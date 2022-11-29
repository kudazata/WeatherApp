//
//  CitiesViewController.swift
//  Weather App
//
//  Created by Kuda Zata on 29/11/2022.
//

import UIKit

class CitiesViewController: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addNewCity))
        addButton.tintColor = .white
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    @objc func addNewCity(){
         print("clicked")
    }
    
}

extension CitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell")!
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
