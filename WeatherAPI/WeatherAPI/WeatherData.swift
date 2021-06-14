//
//  WeatherData.swift
//  WeatherAPI
//
//  Created by Amit Jangirh on 13/06/21.
//

import Foundation

public struct WeatherData: Decodable {
    enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case weather, base, main, visibility, wind, dt, sys, timezone, name
        //case cod
    }
    
    /// City geo location, longitude, latitude
    public var coordinates: LocationCoordinates?
    
    /// more info Weather condition codes
    public var weather: [Weather]?
    
    /// Internal parameter
    var base: String?
    
    public var main: Main?
    
    public var visibility: Int?
    
    public var wind: Wind?
    
    public var clouds: Clouds?
    
    /// Time of data calculation, unix, UTC
    public var dt: Int?
    
    public var sys: Sys?
    
    /// Shift in seconds from UTC
    public var timezone: Int?
    
    /// City ID
    public var id: Int?
    
    /// City name
    public var name: String?
    
    /// Internal parameter, its data type varies from Int <-> String
    //var cod: String?
}

public struct LocationCoordinates: Decodable {
    /// longitude
    public var lat: Double?
    
    /// latitude
    public var lon: Double?
}

public struct Weather: Decodable {
    /// Weather condition id
    public var id: Int?
    
    /// Group of weather parameters (Rain, Snow, Extreme etc.)
    public var main: String?
    
    /// Weather condition within the group. You can get the output in your language
    public var description: String?
    
    /// Weather icon id
    public var icon: String?
}

public struct Main: Decodable {
    enum CodingKeys: String, CodingKey {
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case feelsLike = "feels_like"
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
        case temp, pressure, humidity
    }
    
    /// Temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
    public var temp: Double?
    
    /// Temperature. This temperature parameter accounts for the human perception of weather. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
    public var feelsLike: Double?
    
    /// Atmospheric pressure (on the sea level, if there is no sea_level or grnd_level data), hPa
    public var pressure: Double?
    
    /// Humidity, %
    public var humidity: Int?
    
    /// Minimum temperature at the moment.
    /// This is minimal currently observed temperature (within large megalopolises and urban areas).
    /// Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
    public var minTemperature: Double?
    
    /// Maximum temperature at the moment.
    /// This is maximal currently observed temperature (within large megalopolises and urban areas).
    /// Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
    public var maxTemperature: Double?
    
    /// Atmospheric pressure on the sea level, hPa
    public var seaLevel: Double?
    
    /// Atmospheric pressure on the ground level, hPa
    public var groundLevel: Double?
}

public struct Wind: Codable {
    enum CodingKeys: String, CodingKey {
        case degree = "deg"
        case speed, gust
    }
    
    /// Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
    public var speed: Double?
    
    /// Wind direction, degrees (meteorological)
    public var degree: Int?
    
    /// Wind gust. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour
    public var gust: Double
}

public struct Clouds: Codable {
    /// Cloudiness, %
    public var all: Int?
}

public struct Sys: Codable {
    /// Internal parameter
    var type: Int?
    
    /// Internal parameter
    var id: Int?
    
    /// Internal parameter
    public var message: Double?
    
    /// Country code (GB, JP etc.)
    public var country: String?
    
    /// Sunrise time, unix, UTC
    public var sunrise: Int?
    
    /// Sunset time, unix, UTC
    public var sunset: Int?
}
