//
//  UserDefaultInteractor.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 15/06/21.
//

import Foundation

class UserDefaultInteractor: StoreDataInterface {
    let store = UserDefaults.standard
    
    func getValue<T: Codable>(for key: String) -> T? {
        do {
            guard let decodedValue = store.object(forKey: key) as? Data else {
                return nil
            }
            return try JSONDecoder().decode(T.self, from: decodedValue)
        } catch {
            Logger.log(object: "Failed to decode saved data with error: \(error)")
            return nil
        }
    }
    
    func saveValue<T: Codable>(_ value: T, key: String, expiryDate: Date?) {
        do {
            let encodedValue = try JSONEncoder().encode(value)
            store.set(encodedValue, forKey: key)
        } catch {
            Logger.log(object: "Failed to save encoded data with error: \(error)")
        }
    }
    
    func removeValue(for key: String) {
        store.removeObject(forKey: key)
    }
}
