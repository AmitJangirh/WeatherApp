//
//  NetworkExtension.swift
//  WeatherAPI
//
//  Created by Amit Jangirh on 12/06/21.
//

import Foundation
import NetworkConnection

extension NetworkPath {
    static func path(with service: ServiceName, paramters: [ParameterKey: String]? = nil) -> NetworkPath {
        // Adding deafult common param
        var stringParams = [HeaderKey.appID.rawValue: Configuration.current.appAPIkey!]
        // Append more if available
        paramters?.forEach({ (params) in
            let (key, value) = params
            stringParams[key.rawValue] = value
        })
        return NetworkPath(domain: Configuration.current.baseURL, service: service.rawValue, paramters: stringParams)
    }
}

extension NetworkHeaders {
    static func headers(_ keyValues: [HeaderKey: String]? = nil) -> NetworkHeaders {
        // Adding common Authentication key
        var newHeaders = [String: String]()
        // Adding new headers if available
        keyValues?.forEach { (args) in
            let (key, value) = args
            newHeaders[key.rawValue] = value
        }
        return NetworkHeaders.commonHeaders(with: newHeaders)
    }
}
