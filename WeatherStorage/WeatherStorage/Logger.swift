//
//  Logger.swift
//  WeatherStorage
//
//  Created by Amit Jangirh on 16/06/21.
//

import Foundation

struct Logger {
    static func log(object: Any...) {
        #if DEBUG
        debugPrint(object)
        #endif
    }
}
