//
//  MockData.swift
//  WeatherAPITests
//
//  Created by Amit Jangirh on 13/06/21.
//

import Foundation
@testable import WeatherAPI

extension WeatherData {
    static var data0: WeatherData {
        WeatherData(coordinates: LocationCoordinates(lat: 28.1, lon: 76.2833),
                    weather: nil,
                    base: nil,
                    main: nil,
                    visibility: nil,
                    wind: nil,
                    clouds: nil,
                    dt: nil,
                    sys: nil,
                    timezone: nil,
                    id: 123,
                    name: "Ateli")
    }
}

extension WeatherData: Equatable {
    public static func == (lhs: WeatherData, rhs: WeatherData) -> Bool {
        return lhs.coordinates?.lat == rhs.coordinates?.lat &&
            lhs.coordinates?.lon == rhs.coordinates?.lon &&
            lhs.id == rhs.id &&
            lhs.name == rhs.name
    }
}
