//
//  WeatherAPI.swift
//  WeatherAPI
//
//  Created by Amit Jangirh on 12/06/21.
//

import Foundation

/// WeatherAPI is Interface to access all APIs
/// Access current weather data for any location on Earth including over 200,000 cities!
public protocol WeatherAPIInterface {
    
    /// Get current weather of a city defined by Location.
    /// - Parameters:
    ///   - location: Description of location by city name, state code, country code
    ///   - completion: Provides reponse json object is success, else error
    func currentWeather(for location: Location, completion: @escaping (Result<WeatherData, WeatherAPIError>) -> Void)
    
    /// Get current weather of a city defined by city Id.
    /// - Parameters:
    ///   - cityId: Int value
    ///   - completion: Provides reponse json object is success, else error
    func currentWeather(for cityId: UInt, completion: @escaping (Result<WeatherData, WeatherAPIError>) -> Void)
    
    /// Get current weather of a city defined by coordinates.
    /// - Parameters:
    ///   - coardinated: Defined by Lat and long.
    ///   - completion: Provides reponse json object is success, else error
    func currentWeather(for coardinates: Coordinates, completion: @escaping (Result<WeatherData, WeatherAPIError>) -> Void)
    
    
    /// Get current weather of a ZipCode and country Code. If country code is empty, then default is "US"
    /// - Parameters:
    ///   - zipCode: Zip Code
    ///   - countryCode: Country Code
    ///   - completion: Provides reponse json object is success, else error
    func currentWeather(with zipCode: String, countryCode: String, completion: @escaping (Result<WeatherData, WeatherAPIError>) -> Void)
}

/// Globar getter to get the Interface instance. By which one have access to all the APIs
public var weatherAPI: WeatherAPIInterface {
    WeatherAPI()
}
