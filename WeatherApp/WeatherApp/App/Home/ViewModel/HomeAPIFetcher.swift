//
//  HomeAPIFetcher.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 14/06/21.
//

import Foundation
import WeatherAPI

protocol HomeAPIFetchable {
    func fetchWeather(for cities: [CityWeatherStoreData], completion: @escaping ([WeatherData]?, WeatherAPIError?) -> Void)
}

class HomeAPIFetcher: HomeAPIFetchable {
    let apiInterface: WeatherAPIInterface
    let dispacthGroup = DispatchGroup()
    // Updater
    var weatherDataArray: [WeatherData]?
    var error: WeatherAPIError?
    
    init(apiInterface: WeatherAPIInterface = weatherAPI) {
        self.apiInterface = apiInterface
    }
    
    func fetchWeather(for cities: [CityWeatherStoreData], completion: @escaping ([WeatherData]?, WeatherAPIError?) -> Void) {
        // Reset data
        self.weatherDataArray = []
        self.error = nil
        // Fetching in loop
        for city in cities {
            dispacthGroup.enter()
            let cityId = city.cityId
            self.fetchWeather(for: cityId ?? 0) { (result: Result<WeatherData, WeatherAPIError>) in
                switch result {
                case .success(let weatherData):
                    self.weatherDataArray?.append(weatherData)
                case .failure(let weatherAPIError):
                    self.error = weatherAPIError
                }
                self.dispacthGroup.leave()
            }
            dispacthGroup.wait()
        }
        self.dispacthGroup.notify(queue: DispatchQueue.main) {
            completion(self.weatherDataArray, self.error)
        }
    }

    func fetchWeather(for cityId: UInt, completion: @escaping (Result<WeatherData, WeatherAPIError>) -> Void) {
        apiInterface.currentWeather(for: cityId) { (result: Result<WeatherData, WeatherAPIError>) in
            completion(result)
        }
    }
}
