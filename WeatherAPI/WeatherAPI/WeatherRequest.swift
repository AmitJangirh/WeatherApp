//
//  WeatherRequest.swift
//  WeatherAPI
//
//  Created by Amit Jangirh on 13/06/21.
//

import Foundation

public struct Location {
    public var cityName: String
    public var stateCode: String?
    public var coutryCode: String?
    
    public init(cityName: String, stateCode: String? = nil, coutryCode: String? = nil) {
        self.cityName = cityName
        self.stateCode = stateCode
        self.coutryCode = coutryCode
    }
}

public struct Coordinates {
    public var latitude: Double
    public var logitude: Double
}

public enum Units: String {
    case standard
    case metric
    case imperial
}
