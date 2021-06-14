//
//  Configuration.swift
//  WeatherAPI
//
//  Created by Amit Jangirh on 12/06/21.
//

import Foundation

enum Enviornment {
    case dev
    case production
}

extension Enviornment {
    var appAPIkey: String {
        // Setup different Enviornments
        switch self {
        case .dev: return "fae7190d7e6433ec3a45285ffcf55c86"
        case .production: return "fae7190d7e6433ec3a45285ffcf55c86"
        }
    }
    var domain: String {
        "http://api.openweathermap.org/data"
    }
}

struct Configuration {
    let version = "2.5"
    let appAPIkey: String!
    let domain: String!
    private let enviornment: Enviornment

    init(enviornment: Enviornment) {
        self.enviornment = enviornment
        self.appAPIkey = enviornment.appAPIkey
        self.domain = enviornment.domain
    }
}

extension Configuration {
    var baseURL: String {
        self.domain + "/" + self.version
    }
    
    /// Setting current configuration
    /// This is be read from XCConfig or from a file
    /// hard code default enviornment to production
    static let current = Configuration(enviornment: .production)
}