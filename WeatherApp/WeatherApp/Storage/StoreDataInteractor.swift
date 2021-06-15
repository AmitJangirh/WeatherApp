//
//  StoreDataInteractor.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 14/06/21.
//

import Foundation

protocol StoreDataInterface {
    func getValue<T: Codable>(for key: String) -> T?
    func saveValue<T: Codable>(_ value: T, key: String)
    func removeValue(for key: String)
}
