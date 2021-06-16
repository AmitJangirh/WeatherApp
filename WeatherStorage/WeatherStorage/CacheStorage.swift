//
//  CacheStorage.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 15/06/21.
//

import Foundation

class CacheValue: ExpirableValue {
    var value: Data
    var expiryDate: Date?
    
    init(value: Data, expiryDate: Date? = nil) {
        self.value = value
        self.expiryDate = expiryDate
    }
}

class CacheStorage: NSObject, StoreDataInterface {
    lazy var store: NSCache<NSString, CacheValue> = {
        let store = NSCache<NSString, CacheValue>()
        store.delegate = self
        return store
    }()
    
    func getValue<T: Codable>(for key: String, of type: T.Type) -> T? {
        do {
            guard let cacheValue = store.object(forKey: NSString(string: key)) else {
                return nil
            }
            if cacheValue.isExpired {
                removeValue(for: key)
                return nil
            }
            return try JSONDecoder().decode(T.self, from: cacheValue.value)
        } catch {
            Logger.log(object: "Failed to decode saved data with error: \(error)")
            return nil
        }
    }
    
    func saveValue<T: Codable>(_ value: T, key: String, expiryDate: Date?) {
        do {
            let encodedValue = try JSONEncoder().encode(value)
            let cacheValue = CacheValue(value: encodedValue, expiryDate: expiryDate)
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

extension CacheStorage: NSCacheDelegate {
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        Logger.log(object: "willEvictObject obj \(obj)")
    }
}
