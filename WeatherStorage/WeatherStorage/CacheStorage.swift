//
//  CacheStorage.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 15/06/21.
//

import Foundation

class CacheValue {
    var value: Any
    
    init(value: Any) {
        self.value = value
    }
}

class CacheStorage: NSObject, StoreDataInterface {
    lazy var store: NSCache<NSString, CacheValue> = {
        let store = NSCache<NSString, CacheValue>()
        //store.delegate = self
        return store
    }()
    
    func getValue<T: Codable>(for key: String, of type: T.Type) -> T? {
        guard let cacheValue = store.object(forKey: NSString(string: key)) else {
            return nil
        }
        return cacheValue.value as? T
    }
    
    func saveValue<T: Codable>(_ value: T, key: String, expiryDate: Date?) {
        let cacheValue = CacheValue(value: value)
        store.setObject(cacheValue, forKey: NSString(string: key))
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
