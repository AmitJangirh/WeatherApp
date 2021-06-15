//
//  CityListFetcher.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 15/06/21.
//

import Foundation

struct SearchCityData: Codable {
    enum CodingKeys: String, CodingKey {
        case cityId = "id"
        case cityName = "name"
        case coordinates = "coord"
        case state, country
    }
    
    var cityId: UInt
    var cityName: String
    var state: String
    var country: String
    var coordinates: Coordinates
}

struct Coordinates: Codable {
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
    
    var latitude: Double
    var longitude: Double
}

protocol CityListFetchable {
    func fetchCityList(completion: @escaping ([SearchCityData]?) -> Void)
}

class CityListFetcher {
    enum StoreKey: String {
        case cityListData = "CityListFetcher_AllCities"
    }
    
    //private let store: StoreDataInterface
    private let jsonEncoder: FileJsonEncoder.Type
    
    // NOTE: Was using CacheStorage for all city list
    // but it is getting evicted, so can using global vars
//    init(store: StoreDataInterface = CacheStorageInteractor(),
//         jsonEncoder: FileJsonEncoder.Type = FileParser.self) {
//        self.store = store
//        self.jsonEncoder = jsonEncoder
//    }
    
    init(jsonEncoder: FileJsonEncoder.Type = FileParser.self) {
        self.jsonEncoder = jsonEncoder
    }
}

extension CityListFetcher: CityListFetchable {
    func fetchCityList(completion: @escaping ([SearchCityData]?) -> Void) {
        // First get it from Cache
        if let caheValue = cityListData {
            completion(caheValue)
            return
        }
        // Else, get from bundle file
        do {
            let allData = try jsonEncoder.jsonDecode(jsonFile: .cityList, modelType: [SearchCityData].self)
            self.cityListData = allData
            completion(allData)
        }
        catch {
            Logger.log(object: "Failed to load local data json content with error, \(error)")
            completion(nil)
        }
    }
}

// not using cache store
//extension CityListFetcher {
//    // getter
//    var cityListData: [SearchCityData]? {
//        get {
//            return store.getValue(for: StoreKey.cityListData.rawValue)
//        }
//        set {
//            if let data = newValue {
//                store.saveValue(data, key: StoreKey.cityListData.rawValue)
//            } else {
//                store.removeValue(for: StoreKey.cityListData.rawValue)
//            }
//        }
//    }
//}

// Using Gloabal Dict
var globarDictionary: [String: Any] = [:]
extension CityListFetcher {
    // getter
    var cityListData: [SearchCityData]? {
        get {
            return globarDictionary[StoreKey.cityListData.rawValue] as? [SearchCityData]
        }
        set {
            if let data = newValue {
                globarDictionary[StoreKey.cityListData.rawValue] = data
            } else {
                globarDictionary.removeValue(forKey: StoreKey.cityListData.rawValue)
            }
        }
    }
}

