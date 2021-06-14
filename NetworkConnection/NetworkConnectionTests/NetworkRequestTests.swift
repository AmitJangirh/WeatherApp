//
//  NetworkRequestTests.swift
//  NetworkConnectionTests
//
//  Created by Amit Jangirh on 21/05/21.
//

import Foundation
@testable import NetworkConnection
import XCTest

class NetworkRequestTests: XCTestCase {
    let domain = "http://networkPathTest.com"
    let service = "service/submethod"
    let parameters: [String: String] = ["id": "1", "name": "testName"]
    let headerValue = ["key1": "value1", "key2": "value2"]

    var networkPath: NetworkPath {
        return NetworkPath(domain: domain, service: service, paramters: parameters)
    }
    var body: MockRequestBody {
        MockRequestBody()
    }
    var headers: NetworkHeaders {
        NetworkHeaders(headers: headerValue)
    }
    
    func test_networkRequest_creation_with_pathBodyHeaders() throws {
        var request = NetworkRequest(path: networkPath)
        try? request?.setBody(body)
        request?.setHeaders(headers)
        let urlRequest = request!.urlRequest
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?.count, 2)
        XCTAssertNotNil(urlRequest.httpBody)
        XCTAssertTrue(urlRequest.url!.absoluteString.contains("http://networkPathTest.com/service/submethod?"))
        let component = URLComponents(string: urlRequest.url!.absoluteString)
        let paramDict = component?.queryItems?.map({ [$0.name:$0.value] })
        XCTAssertTrue(paramDict!.contains(["id": "1"]))
        XCTAssertTrue(paramDict!.contains(["name": "testName"]))
    }
}

struct MockRequestBody: Codable {
    var stringValue: String = "Sample"
    var intValue: Int = 22
    var floatValue: Float = 22.3
}
 
