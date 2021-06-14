//
//  Utilities.swift
//  WeatherAPITests
//
//  Created by Amit Jangirh on 13/06/21.
//

import Foundation
@testable import WeatherAPI
import XCTest

extension Result {
    var object: Success? {
        return try? self.get()
    }
    var eventError: WeatherAPIError? {
        if case let .failure(error) = self, let eventError = error as? WeatherAPIError {
            return eventError
        }
        return nil
    }
}
