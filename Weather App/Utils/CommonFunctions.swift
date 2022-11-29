//
//  CommonFunctions.swift
//  Weather App
//
//  Created by Kuda Zata on 29/11/2022.
//

import Foundation
import UIKit

/// This function creates a UIAlert from any view controller within the app. This alert shows two buttons: "Retry" and "Cancel"
/// - Parameters:
///   - title: The title of the alert (eg "Network Error")
///   - message: The text body of the alert
///   - vc: the ViewController from which the alert will be displayed
///   - completion: A completion block to be executed when a user clicks on the Retry button
func showRetryAlert(title: String!, message: String!, vc: UIViewController, completion: @escaping (() -> Void)) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

    alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: { action in
        completion()
    }))
    
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { action in
    }))

    vc.present(alert, animated: true, completion: nil)

}
