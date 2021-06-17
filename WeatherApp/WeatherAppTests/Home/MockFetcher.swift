//
//  MockFetcher.swift
//  WeatherAppTests
//
//  Created by Amit Jangirh on 14/06/21.
//

import Foundation
@testable import WeatherApp

struct MockStorageFetcher: HomeStorageFetchable {
    var cityWeatherData: [CityWeatherStoreData]?
}

extension CityWeatherStoreData {
    static var data0: [CityWeatherStoreData] {
        [CityWeatherStoreData(cityId: 123, latitude: -12, longitude: 1234, state: "Mah", country: "Ind", cityName: "Ateli")]
    }
}
