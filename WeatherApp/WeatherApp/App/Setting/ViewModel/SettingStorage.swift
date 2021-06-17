//
//  SettingStorage.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 18/06/21.
//

import Foundation
import WeatherStorage

class SettingStorage {
    // MARK: - Single Instance
    static let sharedInstance = SettingStorage()
    static var shared: SettingStorage {
        return sharedInstance
    }
    
    private init() {}
    
    // MARK: - Vars
    var storage: StoreDataInterface = userDefaultStorage
    
    // MARK: - Enum Keys
    enum Key: String {
        case temperatureUnit
    }
    
    // MARK: - Getter-Setter
    var temperatureUnit: TemperatureRow.TemperatureUnit {
        get {
            if let value = storage.getValue(for: Key.temperatureUnit.rawValue, of: String.self) {
                return TemperatureRow.TemperatureUnit(rawValue: value) ?? TemperatureRow.TemperatureUnit.defaultValue
            }
            return TemperatureRow.TemperatureUnit.defaultValue
        }
        set {
            storage.saveValue(newValue.rawValue, key: Key.temperatureUnit.rawValue)
        }
    }
}
