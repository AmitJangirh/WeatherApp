//
//  WeatherRepository.swift
//  WeatherAPI
//
//  Created by Amit Jangirh on 16/06/21.
//

import Foundation

class WeatherRepository {
    static func getWeatherData(with query: String,
                               completion: @escaping (Result<WeatherData, WeatherAPIError>) -> Void) {
        if let weatherData = nonExpiredWeatherData(key: query) {
            completion(.success(weatherData))
            return
        }
        WeatherService.getWeatherData(with: query) { (result) in
            switch result {
            case .success(let weatherData):
                saveNewWeatherData(data: weatherData, key: query)
                completion(.success(weatherData))
            case .failure(let weatherAPIError):
                completion(.failure(weatherAPIError))
            }
        }
    }

    static func getWeatherData(with cityId: UInt,
                               completion: @escaping (Result<WeatherData, WeatherAPIError>) -> Void) {
        if let weatherData = nonExpiredWeatherData(key: "\(cityId)") {
            completion(.success(weatherData))
            return
        }
        WeatherService.getWeatherData(with: cityId) { (result) in
            switch result {
            case .success(let weatherData):
                saveNewWeatherData(data: weatherData, key: "\(cityId)")
                completion(.success(weatherData))
            case .failure(let weatherAPIError):
                completion(.failure(weatherAPIError))
            }
        }
    }

    static func getWeatherData(withLat lat: Double,
                               lon: Double,
                               completion: @escaping (Result<WeatherData, WeatherAPIError>) -> Void) {
        let storeKey = "\(lat),\(lon)"
        if let weatherData = nonExpiredWeatherData(key: storeKey) {
            completion(.success(weatherData))
            return
        }
        WeatherService.getWeatherData(withLat: lat, lon: lon) { (result) in
            switch result {
            case .success(let weatherData):
                saveNewWeatherData(data: weatherData, key: storeKey)
                completion(.success(weatherData))
            case .failure(let weatherAPIError):
                completion(.failure(weatherAPIError))
            }
        }
    }

    static func getWeatherData(with zipCode: String,
                               countryCode: String,
                               completion: @escaping (Result<WeatherData, WeatherAPIError>) -> Void) {
        let storeKey = "\(zipCode),\(countryCode)"
        if let weatherData = nonExpiredWeatherData(key: storeKey) {
            completion(.success(weatherData))
            return
        }
        WeatherService.getWeatherData(with: zipCode, countryCode: countryCode) { (result) in
            switch result {
            case .success(let weatherData):
                saveNewWeatherData(data: weatherData, key: storeKey)
                completion(.success(weatherData))
            case .failure(let weatherAPIError):
                completion(.failure(weatherAPIError))
            }
        }
    }
}

extension WeatherRepository {
    static func nonExpiredWeatherData(key: String) -> WeatherData? {
        let expiryHandler = ExpiryDataHandler()
        return expiryHandler.getStoredValue(key: key, type: WeatherData.self)
    }
    
    static func saveNewWeatherData(data: WeatherData, key: String) {
        let expiryHandler = ExpiryDataHandler()
        return expiryHandler.saveNewValue(data: data, key: key)
    }
}
