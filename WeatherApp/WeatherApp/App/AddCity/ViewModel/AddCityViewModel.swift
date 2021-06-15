//
//  AddCityViewModel.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 14/06/21.
//

import Foundation

class AddCityViewModel {
    var locationFetcher: LocationFetchable
    var geoLocationFetcher: GeoLocationFetchable?
    var selectedCity: SelectedCityData?

    init(locationFetcher: LocationFetchable = LocationFetcher()) {
        self.locationFetcher = locationFetcher
    }
    
    func fetchLocation(completion: @escaping (AddCityData?) -> Void) {
        self.locationFetcher.fetchLocation { [weak self] (coordinates, error) in
            if let coord = coordinates {
                self?.fetchGeoLocation(coord: coord, completion: completion)
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchGeoLocation(coord: Coordinates, completion: @escaping (AddCityData?) -> Void) {
        geoLocationFetcher?.fetchGeoLocation(lat: coord.latitude,
                                             lon: coord.longitude) { (geoLocation, error) in
            if let cityName = geoLocation?.cityName,
               let latitude = geoLocation?.latitude,
               let longitude = geoLocation?.longitude {
                let city = AddCityData(cityName: cityName,
                                       cityId: 0,
                                       latitude: latitude,
                                       longitude: longitude)
                completion(city)
                return
            }
            completion(nil)
        }
    }
}
