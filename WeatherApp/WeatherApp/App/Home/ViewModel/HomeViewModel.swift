//
//  HomeViewModel.swift
//  Weather-iOS
//
//  Created by Amit Jangirh on 13/06/21.
//

import Foundation
import WeatherAPI

protocol CityWeatherData {
    var cityId: UInt { get set }
    var cityName: String { get set }
    var temperature: String { get set }
}

struct HomeWeatherData {
    var storeData: CityWeatherData?
    var apiData: WeatherData?
}

extension HomeWeatherData {
    var temperature: String {
        let temp = self.apiData?.main?.temp ?? 0.0
        return "\(temp)" + String(format: "23%@", "\u{00B0}")
    }
}

class HomeViewModel {
    // MARK: - Vars
    var storageFetcher: HomeStorageFetchable
    var apiFetcher: HomeAPIFetchable
    var dataArray = [HomeWeatherData]()
    var isNoContentHidden: Bool {
        return !(dataArray.count == 0)
    }
    
    // MARK: - Init
    init(storageFetcher: HomeStorageFetchable = HomeStorageFetcher(),
         apiFetcher: HomeAPIFetchable = HomeAPIFetcher()) {
        self.storageFetcher = storageFetcher
        self.apiFetcher = apiFetcher
    }
    
    // MARK: - Func
    func fetchData(completion: @escaping () -> Void) {
        let storeData = storageFetcher.cityWeatherData ?? []
        self.dataArray = storeData.map({ HomeWeatherData(storeData: $0, apiData: nil)})
        self.apiFetcher.fetchWeather(for: self.dataArray) { (weatherDataArray, weatherAPIError) in
            self.dataArray = weatherDataArray ?? []
            completion()
        }
    }

    func sectionCount() -> Int {
        return 1
    }
    
    func rowsCount(for section: Int) -> Int {
        return dataArray.count
    }
    
    subscript(indexPath: IndexPath) -> HomeWeatherData? {
        self.dataArray[indexPath.row]
    }
}
