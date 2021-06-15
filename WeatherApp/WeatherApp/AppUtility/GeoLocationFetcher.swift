//
//  GeoLocationFetcher.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 15/06/21.
//

import Foundation
import CoreLocation

/* CLPlacemarks details
name: String?                   // eg. Apple Inc.
thoroughfare: String?           // street name, eg. Infinite Loop
subThoroughfare: String?        // eg. 1
locality: String?               // city, eg. Cupertino
subLocality: String?            // neighborhood, common name, eg. Mission District
administrativeArea: String?     // state, eg. CA
subAdministrativeArea: String?  // county, eg. Santa Clara
postalCode: String?             // zip code, eg. 95014
isoCountryCode: String?         // eg. US
country: String?                // eg. United States
inlandWater: String?            // eg. Lake Tahoe
ocean: String?                  // eg. Pacific Ocean
areasOfInterest: [String]?      // eg. Golden Gate Park
*/

struct GeoLocation {
    var cityName: String?
    var state: String?
    var postalCode: String?
    var country: String?
    var countryCode: String?
    var latitude: Double?
    var longitude: Double?
}

protocol GeoLocationFetchable {
    func fetchGeoLocation(lat: Double, lon: Double, completion: @escaping (GeoLocation?, Error?) -> Void)
}

class GeoLocationFetcher: GeoLocationFetchable {
    let geoCoder = CLGeocoder()

    func fetchGeoLocation(lat: Double, lon: Double, completion: @escaping (GeoLocation?, Error?) -> Void) {
        let location = CLLocation(latitude: lat, longitude: lon)
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let err = error {
                completion(nil, err)
                return
            }
            if let firstPlacemark = placemarks?.first {
                let geoLocation = GeoLocation(cityName: firstPlacemark.locality,
                                              state: firstPlacemark.administrativeArea,
                                              postalCode: firstPlacemark.postalCode,
                                              country: firstPlacemark.country,
                                              countryCode: firstPlacemark.isoCountryCode,
                                              latitude: firstPlacemark.location?.altitude,
                                              longitude: firstPlacemark.location?.altitude)
                completion(geoLocation, nil)
                return
            }
            completion(nil, nil)
        }
    }
}
