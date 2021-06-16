//
//  UIImageExtension.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 16/06/21.
//

import Foundation
import UIKit
import WeatherAPI

extension UIImage {
    static func getImage(icon: String, completion: @escaping (UIImage?) -> Void) {
        weatherAPI.getImageForIcon(icon: icon) { (result: Result<Data, WeatherAPIError>) in
            switch result {
            case .success(let data):
                completion(UIImage(data: data))
            case .failure:
                completion(nil)
            }
        }
    }
}
