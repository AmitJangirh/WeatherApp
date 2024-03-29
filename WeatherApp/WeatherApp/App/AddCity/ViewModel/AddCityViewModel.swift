//
//  AddCityViewModel.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 14/06/21.
//

import Foundation

class AddCityViewModel {
    // MARK: - Fetchers
    var locationFetcher: LocationFetchable
    var geoLocationFetcher: GeoLocationFetchable
    var cityListFether: CityListFetchable
    
    var selectedCity: AddCityData?

    init(locationFetcher: LocationFetchable = LocationFetcher(),
         geoLocationFetcher: GeoLocationFetchable = GeoLocationFetcher(),
         cityListFether: CityListFetchable = CityListFetcher()) {
        self.locationFetcher = locationFetcher
        self.geoLocationFetcher = geoLocationFetcher
        self.cityListFether = cityListFether
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
    
    private func fetchGeoLocation(coord: Coordinates, completion: @escaping (AddCityData?) -> Void) {
        geoLocationFetcher.fetchGeoLocation(lat: coord.latitude,
                                            lon: coord.longitude) { [weak self] (geoLocation, error) in
            if let latitude = geoLocation?.latitude,
               let longitude = geoLocation?.longitude {
                let addcity = AddCity(cityName: geoLocation?.cityName ?? "",
                                      cityId: nil,
                                      latitude: latitude,
                                      longitude: longitude,
                                      state: geoLocation?.state ?? "",
                                      country: geoLocation?.country ?? "")
                self?.fetchMatchingCity(for: addcity, completion: completion)
                return
            }
            completion(nil)
        }
    }
    
    private func fetchMatchingCity(for city: AddCityData, completion: @escaping (AddCityData?) -> Void) {
        // Update city ID from stored list if available
        self.cityListFether.fetchCityList { (searchCityData) in
            var forCity = city
            if let foundCity = searchCityData?.first(where: { $0.cityName == forCity.cityName }) {
                forCity.cityId = foundCity.cityId
                completion(forCity)
                return
            }
            completion(city)
        }
    }
    
    func stopFetching() {
        self.locationFetcher.stopLocationFetching()
    }
}
