//
//  WeatherStorageTests.swift
//  WeatherStorageTests
//
//  Created by Amit Jangirh on 16/06/21.
//

import XCTest
@testable import WeatherStorage

struct UserDefaultData: Codable, Equatable {
    var boolValue: Bool
    var intValue: Int
}

class WeatherStorageTests: XCTestCase {
    var data: UserDefaultData!
    let storekey = "store_test_key"
    
    override func setUpWithError() throws {
        data = UserDefaultData(boolValue: false, intValue: 123)
        userDefaultStorage.removeValue(for: storekey)
        cacheStorage.removeValue(for: storekey)
        persistanceStorage.removeValue(for: storekey)
        memStorage.removeValue(for: storekey)
    }
    
    override func tearDownWithError() throws {
        userDefaultStorage.removeValue(for: storekey)
        cacheStorage.removeValue(for: storekey)
        persistanceStorage.removeValue(for: storekey)
        memStorage.removeValue(for: storekey)
    }
    
    func test_userDefault_saveValue_readValue_deleteValue() throws {
        let sut = userDefaultStorage
        // Existing should be nil
        let existingValue = sut.getValue(for: storekey, of: UserDefaultData.self)
        XCTAssertNil(existingValue)
        // Save value
        sut.saveValue(data, key: storekey)
        // Read value
        let savedValue = sut.getValue(for: storekey, of: UserDefaultData.self)
        XCTAssertEqual(savedValue, data)
        // Delete value
        sut.removeValue(for: storekey)
        XCTAssertNil(existingValue)
    }
    
    func test_cacheStorage_saveValue_readValue_deleteValue() throws {
        let sut = cacheStorage
        // Existing should be nil
        let existingValue = sut.getValue(for: storekey, of: UserDefaultData.self)
        XCTAssertNil(existingValue)
        // Save value
        sut.saveValue(data, key: storekey)
        // Read value
        let savedValue = sut.getValue(for: storekey, of: UserDefaultData.self)
        XCTAssertEqual(savedValue, data)
        // Delete value
        sut.removeValue(for: storekey)
        XCTAssertNil(existingValue)
    }
    
    func test_cacheStorage_withNoExpiry_saveValue_readValue_deleteValue() throws {
        let expiryDate = Date().adding(minutes: 10)
        let sut = cacheStorage
        // Existing should be nil
        let existingValue = sut.getValue(for: storekey, of: UserDefaultData.self)
        XCTAssertNil(existingValue)
        // Save value
        sut.saveValue(data, key: storekey, expiryDate: expiryDate)
        // Read value
        let savedValue = sut.getValue(for: storekey, of: UserDefaultData.self)
        XCTAssertEqual(savedValue, data)
    }
    
    func test_cacheStorage_withExpiry_saveValue_readValue_deleteValue() throws {
        let expiryDate = Date().adding(minutes: -10)
        let sut = cacheStorage
        // Existing should be nil
        let existingValue = sut.getValue(for: storekey, of: UserDefaultData.self)
        XCTAssertNil(existingValue)
        // Save value
        sut.saveValue(data, key: storekey, expiryDate: expiryDate)
        // Read value
        let savedValue = sut.getValue(for: storekey, of: UserDefaultData.self)
        XCTAssertNil(savedValue)
    }
    
    func test_persistanceStorage_withNoExpiry_saveValue_readValue_deleteValue() throws {
        let expiryDate = Date().adding(minutes: 10)
        let sut = persistanceStorage
        // Existing should be nil
        let existingValue = sut.getValue(for: storekey, of: UserDefaultData.self)
        XCTAssertNil(existingValue)
        // Save value
        sut.saveValue(data, key: storekey, expiryDate: expiryDate)
        // Read value
        let savedValue = sut.getValue(for: storekey, of: UserDefaultData.self)
        XCTAssertEqual(savedValue, data)
    }
    
    func test_persistanceStorage_withExpiry_saveValue_readValue_deleteValue() throws {
        let expiryDate = Date().adding(minutes: -10)
        let sut = persistanceStorage
        // Existing should be nil
        let existingValue = sut.getValue(for: storekey, of: UserDefaultData.self)
        XCTAssertNil(existingValue)
        // Save value
        sut.saveValue(data, key: storekey, expiryDate: expiryDate)
        // Read value
        let savedValue = sut.getValue(for: storekey, of: UserDefaultData.self)
        XCTAssertNil(savedValue)
    }
    
    func test_memStorage_withNoExpiry_saveValue_readValue_deleteValue() throws {
        let expiryDate = Date().adding(minutes: 10)
        let sut = memStorage
        // Existing should be nil
        let existingValue = sut.getValue(for: storekey, of: UserDefaultData.self)
        XCTAssertNil(existingValue)
        // Save value
        sut.saveValue(data, key: storekey, expiryDate: expiryDate)
        // Read value
        let savedValue = sut.getValue(for: storekey, of: UserDefaultData.self)
        XCTAssertEqual(savedValue, data)
    }
    
    func test_memStorage_withExpiry_saveValue_readValue_deleteValue() throws {
        let expiryDate = Date().adding(minutes: -10)
        let sut = memStorage
        // Existing should be nil
        let existingValue = sut.getValue(for: storekey, of: UserDefaultData.self)
        XCTAssertNil(existingValue)
        // Save value
        sut.saveValue(data, key: storekey, expiryDate: expiryDate)
        // Read value
        let savedValue = sut.getValue(for: storekey, of: UserDefaultData.self)
        XCTAssertNil(savedValue)
    }
}

extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}
