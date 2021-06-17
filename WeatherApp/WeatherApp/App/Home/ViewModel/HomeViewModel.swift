//
//  HomeViewModel.swift
//  Weather-iOS
//
//  Created by Amit Jangirh on 13/06/21.
//

import Foundation
import WeatherAPI
import CoreGraphics
import UIKit


class HomeViewModel {
    // MARK: - Constant
    struct Constant {
        static let cellHeight: CGFloat = 130
        static var itemsPerRow: CGFloat {
            if UIDevice.isIPad {
                return 2
            } else {
                if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
                    return 2
                }
                return 1
            }
        }
        static let sectionInsets = UIEdgeInsets(top: 50.0,
                                                 left: 20.0,
                                                 bottom: 50.0,
                                                 right: 20.0)
    }
    
    // MARK: - Vars
    var storageFetcher: HomeStorageFetchable
    var apiFetcher: HomeAPIFetchable
    // Data Array
    private var storeWeatherArray = [CityWeatherStoreData]()
    private var apiWeatherArray = [WeatherData]()
    var selectedIndexPaths = [IndexPath: Bool]()
    var haveContent: Bool {
        return storeWeatherArray.count > 0
    }
    var isEditing: Bool = false
    
    // MARK: - Init
    init(storageFetcher: HomeStorageFetchable = HomeStorageFetcher(),
         apiFetcher: HomeAPIFetchable = HomeAPIFetcher()) {
        self.storageFetcher = storageFetcher
        self.apiFetcher = apiFetcher
    }
    
    // MARK: - Func
    func fetchData(completion: @escaping () -> Void) {
        self.storeWeatherArray = storageFetcher.cityWeatherData ?? []
        updateWeather(completion: completion)
    }
    
    private func updateWeather(completion: @escaping () -> Void) {
        self.apiFetcher.fetchWeather(for: self.storeWeatherArray) { (weatherDataArray, weatherAPIError) in
            self.apiWeatherArray = weatherDataArray ?? []
            completion()
        }
    }
    
    func addCity(addCity: AddCityData, completion: @escaping () -> Void) {
        let existingCities = self.storeWeatherArray.filter({  (storeData) -> Bool in
            return areEqual(storeData: storeData, addData: addCity)
        })
        if existingCities.count > 0 {
            // Show alert
            return
        }
        let storeCity = CityWeatherStoreData(addCityData: addCity)
        self.storeWeatherArray.append(storeCity)
        self.storageFetcher.cityWeatherData = self.storeWeatherArray
        // Update weather
        updateWeather(completion: completion)
    }
    
    func sizeOfItem(at indexpath: IndexPath) -> CGSize {
        let deviceWidth = UIScreen.main.bounds.size.width
        let paddingSpace = Constant.sectionInsets.left * (Constant.itemsPerRow + 1)
        let availableWidth = deviceWidth - paddingSpace
        let widthPerItem = availableWidth / Constant.itemsPerRow
        return CGSize(width: widthPerItem, height: Constant.cellHeight)
    }
    
    func insetForSectionAt(at section: Int) -> UIEdgeInsets {
        return Constant.sectionInsets
    }

    func sectionCount() -> Int {
        return 1
    }
    
    func rowsCount(for section: Int) -> Int {
        return storeWeatherArray.count
    }
    
    subscript(storeData indexPath: IndexPath) -> CityWeatherStoreData {
        return self.storeWeatherArray[indexPath.row]
    }
    
    subscript(cellViewModel indexPath: IndexPath) -> HomeTableViewCellViewModel {
        let storeData = self[storeData: indexPath]
        let apiData = mappingAPIData(for: storeData)
        return HomeTableViewCellViewModel(storeData: storeData, apiData: apiData)
    }
    
    subscript(apiData indexPath: IndexPath) -> WeatherData? {
        let storeData = self[storeData: indexPath]
        return self.apiWeatherArray.first { (weatherData) -> Bool in
            return areEqual(storeData: storeData, apiData: weatherData)
        }
    }
    
    private func mappingAPIData(for storeData: CityWeatherStoreData) -> WeatherData? {
        return self.apiWeatherArray.first { (weatherData) -> Bool in
            return areEqual(storeData: storeData, apiData: weatherData)
        }
    }
    
    func deleteItems(at indexPaths: [IndexPath], completion: @escaping () -> Void) {
        indexPaths.forEach { (indexPath) in
            self.storeWeatherArray.remove(at: indexPath.row)
        }
        // Update in Store
        self.storageFetcher.cityWeatherData = self.storeWeatherArray
        // Call API to fetch new data
        updateWeather(completion: completion)
    }
}

extension HomeTableViewCellViewModel {
    init(storeData: CityWeatherStoreData, apiData: WeatherData?) {
        self.cityName = storeData.cityName
        if let temp = apiData?.main?.temp {
            self.temperature = "\(temp)"
        } else {
            self.temperature = "..."
        }
        self.decription = apiData?.weather?.first?.description ?? "..."
        self.iconName = apiData?.weather?.first?.icon
    }
}

extension CityWeatherStoreData {
    init(addCityData: AddCityData) {
        self.init(cityId: addCityData.cityId,
                  latitude: addCityData.latitude,
                  longitude: addCityData.longitude,
                  state: addCityData.state,
                  country: addCityData.country,
                  cityName: addCityData.cityName)
    }
}

func areEqual(storeData: CityWeatherStoreData, apiData: WeatherData) -> Bool {
    if let cityId = storeData.cityId, let apiCityId = apiData.id {
        return cityId == apiCityId
    }
    return storeData.cityName == apiData.name
}

func areEqual(storeData: CityWeatherStoreData, addData: AddCityData) -> Bool {
    if let cityId = storeData.cityId, let addCityId = addData.cityId {
        return cityId == addCityId
    }
    return storeData.cityName == addData.cityName
}
