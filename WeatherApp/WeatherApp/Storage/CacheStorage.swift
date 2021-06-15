//
//  CacheStorage.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 15/06/21.
//

import Foundation

class CacheValue {
    var value: Data
    
    init(value: Data) {
        self.value = value
    }
}

class CacheStorageInteractor: NSObject, StoreDataInterface {
    lazy var store: NSCache<NSString, CacheValue> = {
        let store = NSCache<NSString, CacheValue>()
        store.delegate = self
        return store
    }()
    
    func getValue<T: Codable>(for key: String) -> T? {
        do {
            guard let cacheValue = store.object(forKey: NSString(string: key)) else {
                return nil
            }
            return try JSONDecoder().decode(T.self, from: cacheValue.value)
        } catch {
            Logger.log(object: "Failed to decode saved data with error: \(error)")
            return nil
        }
    }
    
    func saveValue<T: Codable>(_ value: T, key: String) {
        do {
            let encodedValue = try JSONEncoder().encode(value)
            let cacheValue = CacheValue(value: encodedValue)
            store.setObject(cacheValue, forKey: NSString(string: key))
            
            let storeV = store.object(forKey: NSString(string: key))
            print("saved \(storeV!.value)")
        } catch {
            Logger.log(object: "Failed to save encoded data with error: \(error)")
        }
    }
    
    func removeValue(for key: String) {
        store.removeObject(forKey: NSString(string: key))
    }
}

extension CacheStorageInteractor: NSCacheDelegate {
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        Logger.log(object: "willEvictObject obj \(obj)")
    }
}
