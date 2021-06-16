//
//  StoreDataInteractor.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 14/06/21.
//

import Foundation

public protocol StoreDataInterface {
    func getValue<T: Codable>(for key: String, of type: T.Type) -> T?
    func saveValue<T: Codable>(_ value: T, key: String, expiryDate: Date?)
    func removeValue(for key: String)
}

extension StoreDataInterface {
    public func saveValue<T: Codable>(_ value: T, key: String) {
        saveValue(value, key: key, expiryDate: nil)
    }
}

public var userDefaultStorage: StoreDataInterface {
    UserDefaultInteractor()
}

public var cacheStorage: StoreDataInterface {
    CacheStorageInteractor()
}
