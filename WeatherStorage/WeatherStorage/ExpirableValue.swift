//
//  ExpirableValue.swift
//  WeatherStorage
//
//  Created by Amit Jangirh on 16/06/21.
//

import Foundation

protocol ExpirableValue {
    var value: Data { get set }
    var expiryDate: Date? { get set }
}

extension ExpirableValue {
    var isExpired: Bool {
        guard let expiryDate = self.expiryDate else {
            return false
        }
        let todayDate = Date()
        return expiryDate < todayDate
    }
}
