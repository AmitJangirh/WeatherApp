//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 15/06/21.
//

import Foundation

struct SearchCityData: Decodable {
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
    var coordinates: SearchCityDataCoordinates
}

struct SearchCityDataCoordinates: Decodable {
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
    
    var latitude: Double
    var longitude: Double
}

class SearchViewModel {
    struct Constant {
        static let fileName = "City_List"
        static let searchDelay = 250
    }
  
    private var allData = [SearchCityData]()
    private var filteredArray = [SearchCityData]()
    private var searchWorkItem: DispatchWorkItem?
    private var jsonEncoder: FileJsonEncoder.Type

    init(allData: [SearchCityData] = [], jsonEncoder: FileJsonEncoder.Type = FileParser.self) {
        self.allData = []
        self.jsonEncoder = jsonEncoder
    }
    
    func loadData() {
        do {
            self.allData = try jsonEncoder.jsonDecode(jsonFile: .cityList, modelType: [SearchCityData].self)
        } catch {
            Logger.log(object: "Failed to load local data json content with error, \(error)")
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
