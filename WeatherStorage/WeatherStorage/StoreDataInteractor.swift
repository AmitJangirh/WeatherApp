//
//  StoreDataInteractor.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 14/06/21.
//

import Foundation

public protocol StoreDataInterface {
    /// Get stored value
    /// - Parameters:
    ///   - key: Key string against which data stored
    ///   - type: Data Type
    func getValue<T: Codable>(for key: String, of type: T.Type) -> T?
    
    
    /// Save the value
    /// - Parameters:
    ///   - value: Data to store
    ///   - key: Key string against which data stored
    ///   - expiryDate: Optional: Exipry date till data is avaialble for use. If nil, object will be avaialble till it is not removed
    func saveValue<T: Codable>(_ value: T, key: String, expiryDate: Date?)
    
    /// Removed stored value for provided key
    /// - Parameter key: Key string against which data stored
    func removeValue(for key: String)
}

extension StoreDataInterface {
    public func saveValue<T: Codable>(_ value: T, key: String) {
        saveValue(value, key: key, expiryDate: nil)
    }
}

public var userDefaultStorage: StoreDataInterface {
    UserDefaultStorage()
}

public var cacheStorage: StoreDataInterface {
    CacheStorage()
}

public var persistanceStorage: StoreDataInterface {
    PersistanceStorage()
}
