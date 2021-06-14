//
//  HomeViewModel.swift
//  Weather-iOS
//
//  Created by Amit Jangirh on 13/06/21.
//

import Foundation

protocol CityWeatherData: Codable {
    var cityId: UInt { get set }
    var cityName: String { get set }
}

class HomeViewModel {
    // MARK: - Vars
    var storageFetcher: HomeStorageFetchable
    var dataArray = [CityWeatherData]()
    
    // MARK: - Init
    init(storageFetcher: HomeStorageFetchable = HomeStorageFetcher()) {
        self.storageFetcher = storageFetcher
    }
    
    // MARK: - Func
    func fetchData() {
        self.dataArray = storageFetcher.cityWeatherData ?? []
    }
    
    func sectionCount() -> Int {
        return 1
    }
    
    func rowsCount(for section: Int) -> Int {
        return dataArray.count
    }
    
    subscript(indexPath: IndexPath) -> CityWeatherData? {
        self.dataArray[indexPath.row]
    }
}