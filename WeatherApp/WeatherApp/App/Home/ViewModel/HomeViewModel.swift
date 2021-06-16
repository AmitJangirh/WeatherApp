//
//  HomeViewModel.swift
//  Weather-iOS
//
//  Created by Amit Jangirh on 13/06/21.
//

import Foundation
import WeatherAPI

struct HomeData {
    var storeData: CityWeatherStoreData
    var apiData: WeatherData?
    
    init(storeData: CityWeatherStoreData) {
        self.storeData = storeData
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

class HomeViewModel {
    // MARK: - Vars
    var storageFetcher: HomeStorageFetchable
    var apiFetcher: HomeAPIFetchable
    // Data Array
    private var homeDataArray = [HomeData]()
    
    var haveContent: Bool {
        return homeDataArray.count > 0
    }
    
    // MARK: - Init
    init(storageFetcher: HomeStorageFetchable = HomeStorageFetcher(),
         apiFetcher: HomeAPIFetchable = HomeAPIFetcher()) {
        self.storageFetcher = storageFetcher
        self.apiFetcher = apiFetcher
    }
    
    // MARK: - Func
    func fetchData(completion: @escaping () -> Void) {
        self.homeDataArray = storageFetcher.cityWeatherData?.map({ HomeData(storeData: $0) }) ?? []
        updateWeather(completion: completion)
    }
    
    private func updateWeather(completion: @escaping () -> Void) {
        self.apiFetcher.fetchWeather(for: self.homeDataArray) { (weatherDataArray, weatherAPIError) in
            self.mappingStoreData(with: weatherDataArray ?? [])
            completion()
        }
    }
    
    private func mappingStoreData(with weatherData: [WeatherData]) {
        self.homeDataArray = self.homeDataArray.map({ (homeData) -> HomeData in
            var mutatingHomeData = homeData
            mutatingHomeData.apiData = weatherData.first { (apiData) -> Bool in
                return areEqual(storeData: homeData.storeData, apiData: apiData)
            }
            return mutatingHomeData
        })
    }
    
    func addCity(newCity: AddCityData, completion: @escaping () -> Void) {
        let existingCities = self.homeDataArray.filter { (homeData) -> Bool in
            return areEqual(storeData: homeData.storeData, addData: newCity)
        }
        if existingCities.count > 0 {
            // Show alert
            return
        }
        let storeData = CityWeatherStoreData(cityId: newCity.cityId,
                                        latitude: newCity.latitude,
                                        longitude: newCity.longitude,
                                        state: newCity.state,
                                        country: newCity.country,
                                        cityName: newCity.cityName)
        homeDataArray.append(HomeData(storeData: storeData))
        // Updating storage data
        var storeArray = self.storageFetcher.cityWeatherData
        storeArray?.append(storeData)
        self.storageFetcher.cityWeatherData = storeArray
        // Update weather
        updateWeather(completion: completion)
    }

    func sectionCount() -> Int {
        return 1
    }
    
    func rowsCount(for section: Int) -> Int {
        return homeDataArray.count
    }
    
    subscript(indexPath: IndexPath) -> HomeTableViewCellViewModel {
        let homeData = self.homeDataArray[indexPath.row]
        return HomeTableViewCellViewModel(homeData: homeData)
    }
    
    func deleteItem(at indexPath: IndexPath, completion: @escaping () -> Void) {
        self.homeDataArray.remove(at: indexPath.row)
        // Update in Store
        // Updating storage data
        var storeArray = self.storageFetcher.cityWeatherData
        storeArray?.remove(at: indexPath.row)
        self.storageFetcher.cityWeatherData = storeArray
        // Call API to fetch new data
        updateWeather(completion: completion)
    }
}

extension HomeTableViewCellViewModel {
    init(homeData: HomeData) {
        self.cityName = homeData.storeData.cityName
        if let temp = homeData.apiData?.main?.temp {
            self.temperature = "\(temp)"
        } else {
            self.temperature = "..."
        }
        self.decription = homeData.apiData?.weather?.first?.description ?? "..."
        if let icon = homeData.apiData?.weather?.first?.icon {
            self.iconURL = "http://openweathermap.org/img/wn/\(icon)@2x.png"
        } else {
            self.iconURL = nil
        }
    }
}
