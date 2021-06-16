//
//  ExpiryDataHandler.swift
//  WeatherAPI
//
//  Created by Amit Jangirh on 16/06/21.
//

import Foundation
import WeatherStorage

class ExpiryDataHandler {
    let storage: StoreDataInterface
    let expiryTime: Int = 10 // In Minutes
    
    init(storage: StoreDataInterface = persistanceStorage) {
        self.storage = storage
    }
    
    func saveNewValue<T: Codable>(data: T, key: String) {
        let expiryDate = Date().adding(minutes: expiryTime)
        storage.saveValue(data, key: key, expiryDate: expiryDate)
    }
    
    func getStoredValue<T: Codable>(key: String, type: T.Type) -> T? {
        return storage.getValue(for: key, of: type)
    }
}

extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}
