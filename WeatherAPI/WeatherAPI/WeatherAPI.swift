//
//  WeatherAPI.swift
//  WeatherAPI
//
//  Created by Amit Jangirh on 13/06/21.
//

import Foundation

struct WeatherAPI: WeatherAPIInterface {
    func currentWeather(for cityId: UInt,
                        completion: @escaping (Result<WeatherData, WeatherAPIError>) -> Void) {
        WeatherRepository.getWeatherData(with: cityId,
                                         completion: completion)
    }
    
    func currentWeather(for location: Location,
                        completion: @escaping (Result<WeatherData, WeatherAPIError>) -> Void) {
        // TODO: If we have more parameters, then look for other ways to do below task
        var queryString = location.cityName
        if let stateCode = location.stateCode {
            queryString += ",\(stateCode)"
        }
        if let coutryCode = location.coutryCode {
            queryString += ",\(coutryCode)"
        }
        WeatherRepository.getWeatherData(with: queryString,
                                         completion: completion)
    }
    
    func currentWeather(for coardinates: Coordinates,
                        completion: @escaping (Result<WeatherData, WeatherAPIError>) -> Void) {
        WeatherRepository.getWeatherData(withLat: coardinates.latitude,
                                         lon: coardinates.logitude,
                                         completion: completion)
    }
    
    func currentWeather(with zipCode: String,
                        countryCode: String,
                        completion: @escaping (Result<WeatherData, WeatherAPIError>) -> Void) {
        WeatherRepository.getWeatherData(with: zipCode, countryCode: countryCode, completion: completion)
    }
    
    func getImageForIcon(icon: String, completion: @escaping (Data?) -> Void) {
        WeatherRepository.getImageForIcon(icon: icon, completion: completion)
    }
}
