//
//  NetworkError.swift
//  NetworkConnection
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation

/// NetworkError - Common error which can be handled at the Network layer
public enum NetworkError: Error {
    /// Failed to create request URL. Occur before sending the Request
    case invalidRequestURL
    
    /// Failed to Encode Data Object to Raw Data while setting in URLRequest Body
    case failedJsonEncode(Error)
    
    /// Failed to Decode Json to Mapped Object after reponse recieved
    case failedJsonDecode(Error)
    
    /// Network connectivity unavailable
    case networkUnavailable
    
    /// Server error with Error Object
    case error(Error?)
}
