//
//  WeatherAPIError.swift
//  WeatherAPI
//
//  Created by Amit Jangirh on 12/06/21.
//

import Foundation

/// Weather API errors,
public enum WeatherAPIError: Error {
    /// HTTP Status was 200, but response decoded object was nil
    case invalidObject
    
    /// Invalide request created, use which is given in Configuration
    case invalidRequest
    
    /// Network error from Network module
    case networkError(Error)
    
    /// HTTP status code other than valid code
    case statusCode(Int)
    
    /// Access token got expired or is invalid
    case invalidAccessToken
}
