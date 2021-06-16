//
//  MemoryStorage.swift
//  WeatherStorage
//
//  Created by Amit Jangirh on 16/06/21.
//

import Foundation

var globalDictionary: [String: Any] = [:]

struct DictValue<T: Codable>: ExpirableValue, Codable {
    var value: Data
    var actualValue: T
    var expiryDate: Date?
    
    init(value: Data, actualValue: T, expiryDate: Date? = nil) {
        self.value = value
        self.actualValue = actualValue
        self.expiryDate = expiryDate
    }
}

class MemoryStorage: StoreDataInterface {
    
    func getValue<T: Codable>(for key: String, of type: T.Type) -> T? {
        guard let dictValue = globalDictionary[key] as? DictValue<T> else {
            return nil
        }
        if dictValue.isExpired {
            return nil
        }
        return dictValue.actualValue
    }
    
    func saveValue<T: Codable>(_ value: T, key: String, expiryDate: Date?) {
        do {
            let encodedValue = try JSONEncoder().encode(value)
            let dictValue = DictValue(value: encodedValue, actualValue: value, expiryDate: expiryDate)
            globalDictionary[key] = dictValue
        } catch {
            Logger.log(object: "Failed to save encoded data with error: \(error)")
        }
    }
    
    func removeValue(for key: String) {
        globalDictionary.removeValue(forKey: key)
    }
}
