//
//  WeatherAPILogger.swift
//  WeatherAPI
//
//  Created by Amit Jangirh on 12/06/21.
//

import Foundation

struct Logger {
    static func log(object: Any...) {
        #if DEBUG
        print(object)
        #endif
    }
}
