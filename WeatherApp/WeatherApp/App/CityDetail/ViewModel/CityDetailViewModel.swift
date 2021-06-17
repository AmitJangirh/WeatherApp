//
//  CityDetailViewModel.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 17/06/21.
//

import Foundation

protocol CityDetailData {
    var temperature: Double { get }
    var minTemperature: Double { get }
    var maxTemperature: Double { get }
    var pressure: Double { get }
    var humidity: Int { get }
    var visibility: Int { get }
    var weatherDescription: String { get }
    var weatherIcon: String { get }
    var windSpeed: Double { get }
    var windDegree: Int { get }
    var cloudiness: Int { get }
    var cityId: Int { get }
    var cityName: String { get }
}

struct NoData: CityDetailData {
    var temperature: Double = 0
    var minTemperature: Double = 0
    var maxTemperature: Double = 0
    var pressure: Double = 0
    var humidity: Int = 0
    var visibility: Int = 0
    var weatherDescription: String = ""
    var weatherIcon: String = ""
    var windSpeed: Double = 0
    var windDegree: Int = 0
    var cloudiness: Int = 0
    var cityId: Int = 0
    var cityName: String = ""
}

class CityDetailViewModel {
    let data: CityDetailData
    var title: String {
        return ""
    }
    
    init(data: CityDetailData) {
        self.data = data
    }
    
    func sectionCount() -> Int {
        return 1
    }
    
    func rowsCount(for section: Int) -> Int {
        return 0
    }
    
//    subscript(indexPath: IndexPath) -> HomeTableViewCellViewModel {
//        let storeData = self.storeWeatherArray[indexPath.row]
//        let apiData = mappingAPIData(for: storeData)
//        return HomeTableViewCellViewModel(storeData: storeData, apiData: apiData)
//    }
}
