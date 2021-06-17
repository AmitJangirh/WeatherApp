//
//  StringExtension.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 17/06/21.
//

import Foundation

enum TemperatureUnit: String {
    case celsius = "\u{00B0} C"
    case fahrenheit = "\u{00B0} F"
}

enum Unicode: String {
    case upArrow = "\u{2B61}"
    case downArrow = "\u{2B63}"
}

extension String {
    func appendTemperatureUnit(unit: TemperatureUnit) -> String {
        return self + (NSString(format:"%@", unit.rawValue) as String)
    }
    
    func appendUnicode(code: Unicode) -> String {
        return self + (NSString(format:"%@", code.rawValue) as String)
    }
}
