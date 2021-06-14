//
//  MockNetworkAdaptor.swift
//  WeatherAPITests
//
//  Created by Amit Jangirh on 13/06/21.
//

import Foundation
@testable import WeatherAPI
@testable import NetworkConnection
import XCTest

enum TestCase {
    case success(Any)
    case failure(WeatherAPIError)
}

struct Requests {
    var service: ServiceName?
    var method: NetworkMethod?
    var body: Any?
    var parameter: [ParameterKey : String]?
    var header: [HeaderKey : String]?
}

struct MockNetworkAdapter {
    static var requests: Requests?
    static var testCase: TestCase!
    static var expectation: XCTestExpectation!
    
    static func initialise(testCase: TestCase, expectation: XCTestExpectation) {
        self.testCase = testCase
        self.expectation = expectation
    }
    
    static func deinitialise() {
        self.testCase = nil
        self.expectation = nil
        self.requests = nil
    }
}

extension MockNetworkAdapter: NetworkAdaptable {
    static func hitAPI<T, U>(with service: ServiceName,
                             method: NetworkMethod,
                             parameter: [ParameterKey : String]?,
                             header: [HeaderKey : String]?,
                             body: U?,
                             completion: @escaping (Result<T, WeatherAPIError>) -> Void) where T : Decodable, U : Encodable {
        self.requests = Requests(service: service,
                                 method: method,
                                 body: body,
                                 parameter: parameter,
                                 header: header)
        
        switch self.testCase! {
        case .success(let object):
            completion(.success(object as! T))
        case .failure(let error):
            completion(.failure(error))
        }
        
        // Fullfil at last
        expectation.fulfill()
    }
}
