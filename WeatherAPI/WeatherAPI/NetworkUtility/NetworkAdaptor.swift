//
//  NetworkAdaptor.swift
//  WeatherAPI
//
//  Created by Amit Jangirh on 12/06/21.
//

import Foundation
import NetworkConnection

// MARK: - ServiceName, Headers and Parameters

enum ServiceName: String {
    case weather
}

enum ParameterKey: String {
    // Query String
    case query = "q"
    
    // Coordinates
    case latitude = "lat"
    case logitude = "lon"
    
    // Common
    case appID = "appid"
    case units = "units"
    case language = "lang"
    
    // City ID
    case cityID = "id"
    
    // Zip
    case zip = "zip"
}

enum HeaderKey: String {
    // Add headers, not using it as appid is sent in Parameters
    case appID = "appid"
}

// MARK: - NetworkAdaptable Protocol
var networkAdapter: NetworkAdaptable.Type = NetworkAdapter.self

protocol NetworkAdaptable {
    static func hitAPI<T: Decodable, U:Encodable>(with service: ServiceName,
                                                  method: NetworkMethod,
                                                  parameter: [ParameterKey: String]?,
                                                  header: [HeaderKey: String]?,
                                                  body: U?,
                                                  completion: @escaping (Result<T, WeatherAPIError>) -> Void)
}

extension NetworkAdaptable {
    // Utitlity func, append as per use case
    static func getAPI<T: Decodable>(with service: ServiceName,
                                   parameter: [ParameterKey: String]?,
                                   completion: @escaping (Result<T, WeatherAPIError>) -> Void) {
        hitAPI(with: service,
               method: .get,
               parameter: parameter,
               header: nil,
               body: Optional<String>.none,
               completion: completion)
    }
}

// MARK: - NetworkAdapter
struct NetworkAdapter: NetworkAdaptable {
    static func hitAPI<T: Decodable, U:Encodable>(with service: ServiceName,
                                                  method: NetworkMethod,
                                                  parameter: [ParameterKey: String]?,
                                                  header: [HeaderKey: String]?,
                                                  body: U?,
                                                  completion: @escaping (Result<T, WeatherAPIError>) -> Void) {
        let path = NetworkPath.path(with: service, paramters: parameter)
        let headers = NetworkHeaders.headers(header)
        NetworkConnection.shared.sendConnection(path: path,
                                                method: method,
                                                headers: headers,
                                                body: body) { (responseObject: T?, urlResponse, networkError) in
            // Handle Network Error and convert it to WeatherAPIError
            if let error = networkError {
                let eventError = WeatherAPIError.networkError(error)
                completion(.failure(eventError))
                return
            }
            
            // Handle HTTP response for status valid code
            let statusCode = urlResponse?.code ?? 0
            guard statusCode.isValidReponse else {
                completion(.failure(WeatherAPIError.statusCode(statusCode)))
                return
            }
            
            // Handle Data
            if let object = responseObject {
                completion(.success(object))
            } else {
                // Handle nil data from API
                completion(.failure(.invalidObject))
            }
        }
    }
}

extension URLResponse {
    fileprivate var code: Int? {
        if let httpResponse = (self as? HTTPURLResponse) {
            return httpResponse.statusCode
        }
        return nil
    }
}

extension Int {
    fileprivate var isValidReponse: Bool {
        if self == 200 { // Put more status code as per requirements
            return true
        }
        return false
    }
}
