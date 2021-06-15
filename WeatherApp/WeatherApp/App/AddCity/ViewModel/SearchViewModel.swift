//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 15/06/21.
//

import Foundation

class SearchViewModel {
    struct Constant {
        static let fileName = "City_List"
        static let searchDelay = 250
    }
  
    private var allData = [SearchCityData]()
    private var filteredArray = [SearchCityData]()
    private var searchWorkItem: DispatchWorkItem?
    private let cityListFetcher: CityListFetchable

    init(cityListFetcher: CityListFetcher = CityListFetcher()) {
        self.cityListFetcher = cityListFetcher
    }
    
    func loadData(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            self?.cityListFetcher.fetchCityList { [weak self] (allCities) in
                self?.allData = allCities ?? []
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    // Debounce
    func search(cityName: String, completion: @escaping () -> Void) {
        // Cancel the currently pending item
        searchWorkItem?.cancel()
        
        // Wrap our task in a work item
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.searchWork(with: cityName)
        }
        
        // Save the new work item and execute it after 250 ms
        self.searchWorkItem = requestWorkItem
        
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + .milliseconds(Constant.searchDelay), execute: requestWorkItem)
        
        searchWorkItem?.notify(queue: DispatchQueue.main, execute: {
            completion()
        })
    }
    
    private func searchWork(with cityName: String) {
        self.filteredArray = self.allData.filter({ $0.cityName.contains(cityName) })
    }
    
    func sectionCount() -> Int {
        return 1
    }
    
    func rowsCount(for section: Int) -> Int {
        return filteredArray.count
    }
    
    subscript(indexPath: IndexPath) -> SearchCityData? {
        self.filteredArray[indexPath.row]
    }
}
