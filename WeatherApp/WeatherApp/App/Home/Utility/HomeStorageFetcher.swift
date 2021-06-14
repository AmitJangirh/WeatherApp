//
//  HomeStorageFetcher.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 14/06/21.
//

import Foundation

struct CityWeatherStoreData: CityWeatherData, Codable {
    var cityId: UInt
    var cityName: String
    var temperature: String
}

protocol HomeStorageFetchable {
    var cityWeatherData: [CityWeatherStoreData]? { get set }
}

class HomeStorageFetcher {
    enum StoreKey: String {
        case cityWeatherData = "HomeStorageFetcher_CityWeatherData"
    }
    
    let store: StoreDataInterface
    init(store: StoreDataInterface = UserDefaultInteractor()) {
        self.store = store
    }
}

extension HomeStorageFetcher: HomeStorageFetchable {
    var cityWeatherData: [CityWeatherStoreData]? {
        get {
            return store.getValue(for: StoreKey.cityWeatherData.rawValue)
        }
        set {
            if let data = newValue {
                store.saveValue(data, key: StoreKey.cityWeatherData.rawValue)
            } else {
                store.removeValue(for: StoreKey.cityWeatherData.rawValue)
            }
        }
    }
}
