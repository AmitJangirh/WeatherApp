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
    static func getImage(icon: String, completion: @escaping (UIImage) -> Void) {
        weatherAPI.getImageForIcon(icon: icon) { (imageData) in
            if let data = imageData, let image = UIImage(data: data) {
                completion(image)
                return
            }
            completion(UIImage.getImage(imageName: .defaultImage)!)
        }
    }
}

extension UIImage {
    struct ImageName {
        let rawValue: String
        
        static let defaultImage: ImageName = ImageName(rawValue: "DefaultImage")
        static let settingIcon: ImageName = ImageName(rawValue: "SettingIcon")
        static let removeIcon: ImageName = ImageName(rawValue: "RemoveIcon")
    }
    
    static func getImage(imageName: ImageName) -> UIImage? {
        UIImage(named: imageName.rawValue)
    }
}

extension UIDevice {
    static var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
