//
//  LocationFetcher.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 15/06/21.
//

import Foundation
import MapKit

protocol LocationFetchable {
    func fetchLocation(completion: @escaping (Coordinates?, Error?) -> Void)
}

class LocationFetcher: NSObject, LocationFetchable, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var completion: ((Coordinates?, Error?) -> Void)?
    
    func fetchLocation(completion: @escaping (Coordinates?, Error?) -> Void) {
        self.completion = completion
        DispatchQueue.global(qos: .userInteractive).async {
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first?.coordinate else {
            return
        }
        self.completion?(Coordinates(latitude: firstLocation.latitude, longitude: firstLocation.longitude), nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        self.completion?(nil, error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.requestLocation()
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            Logger.log(object: "Denied Permission for get location")
            break
        @unknown default:
            Logger.log(object: "Location manager didChangeAuthorization with unknown status")
        }
    }
}
