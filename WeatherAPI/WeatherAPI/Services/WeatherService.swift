//
//  WeatherService.swift
//  WeatherAPI
//
//  Created by Amit Jangirh on 12/06/21.
//

import Foundation

class WeatherService {
    static func getWeatherData(with query: String, completion: @escaping (Result<WeatherData, WeatherAPIError>) -> Void) {
        let param = [ParameterKey.query: query]
        networkAdapter.getAPI(with: .weather, parameter: param, completion: completion)
    }

    static func getWeatherData(with cityId: UInt, completion: @escaping (Result<WeatherData, WeatherAPIError>) -> Void) {
        let param = [ParameterKey.cityID: "\(cityId)"]
        networkAdapter.getAPI(with: .weather, parameter: param, completion: completion)
    }

    static func getWeatherData(withLat lat: Double, lon: Double, completion: @escaping (Result<WeatherData, WeatherAPIError>) -> Void) {
        let param = [ParameterKey.latitude: "\(lat)",
                     ParameterKey.logitude: "\(lon)"]
        networkAdapter.getAPI(with: .weather, parameter: param, completion: completion)
    }

    static func getWeatherData(with zipCode: String, countryCode: String, completion: @escaping (Result<WeatherData, WeatherAPIError>) -> Void) {
        let param = [ParameterKey.zip: zipCode + "," + countryCode]
        networkAdapter.getAPI(with: .weather, parameter: param, completion: completion)
    }
}
