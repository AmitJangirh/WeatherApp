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
    var storeWeatherArray = [CityWeatherStoreData]()
    var apiWeatherArray = [WeatherData]()
    
    var isNoContentHidden: Bool {
        return !(storeWeatherArray.count == 0)
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
    
    func addCity(newCity: SelectedCityData, completion: @escaping () -> Void) {
        var storeData = self.storageFetcher.cityWeatherData ?? []
        let existingCities = storeData.filter({ $0.cityName == newCity.cityName })
        if existingCities.count > 0 {
            // Show alert
            return
        }
        let city = CityWeatherStoreData(cityId: newCity.cityId, cityName: newCity.cityName, temperature: "")
        storeData.append(city)
        self.storageFetcher.cityWeatherData = storeData
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
        let apiData = apiWeatherArray.first(where: { $0.name == storeData.cityName })
        let temperature = "\(apiData?.main?.temp)" + String(format: "23%@", "\u{00B0}")
        return HomeTableViewCellViewModel(temperature: temperature,
                                                       cityName: storeData.cityName)
    }
}
