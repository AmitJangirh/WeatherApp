//
//  UIViewControllerExtension.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 16/06/21.
//

import Foundation
import UIKit

extension UIViewController {
    func setupCommonNavigation() {
        self.navigationController?.navigationBar.barTintColor = Theme.Color.greyColor
        self.navigationController?.navigationBar.backgroundColor = Theme.Color.greyColor
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Theme.Color.tintColor]
        self.navigationController?.navigationBar.tintColor = Theme.Color.tintColor
    }
}
