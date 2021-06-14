//
//  HomeAPIFetcher.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 14/06/21.
//

import Foundation
import WeatherAPI

protocol HomeAPIFetchable {
    func fetchWeather(for cities: [HomeWeatherData], completion: @escaping ([HomeWeatherData]?, WeatherAPIError?) -> Void)
}

class HomeAPIFetcher: HomeAPIFetchable {
    let apiInterface: WeatherAPIInterface
    let dispacthGroup = DispatchGroup()
    
    init(apiInterface: WeatherAPIInterface = weatherAPI) {
        self.apiInterface = apiInterface
    }
    
    func fetchWeather(for cities: [HomeWeatherData], completion: @escaping ([HomeWeatherData]?, WeatherAPIError?) -> Void) {
        var homeData = cities
        var error: WeatherAPIError?
        for city in homeData {
            dispacthGroup.enter()
            guard let cityId =  city.storeData?.cityId else {
                dispacthGroup.leave()
                return
            }
            apiInterface.currentWeather(for: cityId) { (result: Result<WeatherData, WeatherAPIError>) in
                switch result {
                case .success(let weatherData):
                    //city.apiData = weatherData
                    print(cityId)
                case .failure(let weatherAPIError):
                    error = weatherAPIError
                }
                self.dispacthGroup.leave()
            }
        }
        self.dispacthGroup.notify(queue: DispatchQueue.main) {
            completion(homeData, error)
        }
    }
}
