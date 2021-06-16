//
//  HomeViewModel.swift
//  Weather-iOS
//
//  Created by Amit Jangirh on 13/06/21.
//

import Foundation
import WeatherAPI

class HomeViewModel {
    // MARK: - Vars
    var storageFetcher: HomeStorageFetchable
    var apiFetcher: HomeAPIFetchable
    // Data Array
    private var storeWeatherArray = [CityWeatherStoreData]()
    private var apiWeatherArray = [WeatherData]()
    
    var haveContent: Bool {
        return storeWeatherArray.count > 0
    }
    
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

    func sectionCount() -> Int {
        return 1
    }
    
    func rowsCount(for section: Int) -> Int {
        return storeWeatherArray.count
    }
    
    subscript(indexPath: IndexPath) -> HomeTableViewCellViewModel {
        let storeData = self.storeWeatherArray[indexPath.row]
        let apiData = mappingAPIData(for: storeData)
        return HomeTableViewCellViewModel(storeData: storeData, apiData: apiData)
    }
    
    private func mappingAPIData(for storeData: CityWeatherStoreData) -> WeatherData? {
        return self.apiWeatherArray.first { (weatherData) -> Bool in
            return areEqual(storeData: storeData, apiData: weatherData)
        }
    }
    
    func deleteItem(at indexPath: IndexPath, completion: @escaping () -> Void) {
        self.storeWeatherArray.remove(at: indexPath.row)
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
