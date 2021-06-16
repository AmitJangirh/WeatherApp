//
//  MemoryStorage.swift
//  WeatherStorage
//
//  Created by Amit Jangirh on 16/06/21.
//

import Foundation

var globalDictionary: [String: Any] = [:]

class DictValue: ExpirableValue, Codable {
    var value: Data
    var expiryDate: Date?
    
    init(value: Data, expiryDate: Date? = nil) {
        self.value = value
        self.expiryDate = expiryDate
    }
}

class MemoryStorage: StoreDataInterface {
    
    func getValue<T: Codable>(for key: String, of type: T.Type) -> T? {
        do {
            guard let dictValue = globalDictionary[key] as? DictValue else {
                return nil
            }
            if dictValue.isExpired {
                return nil
            }
            return try JSONDecoder().decode(T.self, from: dictValue.value)
        } catch {
            Logger.log(object: "Failed to decode saved data with error: \(error)")
            return nil
        }
    }
    
    func saveValue<T: Codable>(_ value: T, key: String, expiryDate: Date?) {
        do {
            let encodedValue = try JSONEncoder().encode(value)
            let dictValue = DictValue(value: encodedValue, expiryDate: expiryDate)
            globalDictionary[key] = dictValue
        } catch {
            Logger.log(object: "Failed to save encoded data with error: \(error)")
        }
    }
    
    func removeValue(for key: String) {
        globalDictionary.removeValue(forKey: key)
    }
}
