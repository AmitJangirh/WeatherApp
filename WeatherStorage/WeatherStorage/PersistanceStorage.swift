//
//  PersistanceStorage.swift
//  WeatherStorage
//
//  Created by Amit Jangirh on 16/06/21.
//

import Foundation

class FileValue: ExpirableValue, Codable {
    var value: Data
    var expiryDate: Date?
    
    init(value: Data, expiryDate: Date? = nil) {
        self.value = value
        self.expiryDate = expiryDate
    }
}

class PersistanceStorage: StoreDataInterface {
    let fileManager = FileManager.default
    
    private func fileURL(forFileNamed fileName: String) -> URL? {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(fileName)
    }
    
    func getValue<T: Codable>(for key: String, of type: T.Type) -> T? {
        guard let url = fileURL(forFileNamed: key) else {
            return nil
        }
        guard fileManager.fileExists(atPath: url.path) else {
            Logger.log(object: "file Does Not Exists At: \(url.path)")
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            let fileValue = try JSONDecoder().decode(FileValue.self, from: data)
            if fileValue.isExpired {
                removeValue(for: key)
                return nil
            }
            return try JSONDecoder().decode(T.self, from: fileValue.value)
        } catch {
            Logger.log(object: "Failed to decode saved data with error: \(error)")
            return nil
        }
    }
    
    func saveValue<T: Codable>(_ value: T, key: String, expiryDate: Date?) {
        guard let url = fileURL(forFileNamed: key) else {
            return
        }
        do {
            let encodedValue = try JSONEncoder().encode(value)
            let fileValue = FileValue(value: encodedValue, expiryDate: expiryDate)
            let data = try JSONEncoder().encode(fileValue)
            try data.write(to: url, options: .atomic)
        } catch {
            Logger.log(object: "Failed to save encoded data with error: \(error)")
        }
    }
    
    func removeValue(for key: String) {
        guard let url = fileURL(forFileNamed: key) else {
            return
        }
        do {
            try fileManager.removeItem(at: url)
        } catch {
            Logger.log(object: "Failed to save encoded data with error: \(error)")
        }
    }
}
