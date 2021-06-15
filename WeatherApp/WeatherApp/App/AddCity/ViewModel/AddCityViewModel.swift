//
//  AddCityViewModel.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 14/06/21.
//

import Foundation

class AddCityViewModel {
    var locationFetcher: LocationFetchable
    
    init(locationFetcher: LocationFetchable = LocationFetcher()) {
        self.locationFetcher = locationFetcher
    }
    
    func fetchLocation(completion: @escaping (Double, Double) -> Void) {
        self.locationFetcher.fetchLocation { (coordinates, error) in
            if let coord = coordinates {
                completion(coord.latitude, coord.longitude)
            } else {
                completion(0, 0)
            }
        }
    }
}
