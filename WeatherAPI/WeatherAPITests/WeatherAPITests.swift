//
//  WeatherAPITests.swift
//  WeatherAPITests
//
//  Created by Amit Jangirh on 12/06/21.
//

import XCTest
@testable import WeatherAPI

class WeatherAPITests: XCTestCase {
    
    override func setUpWithError() throws {
        networkAdapter = MockNetworkAdapter.self
    }
    
    override func tearDownWithError() throws {
        MockNetworkAdapter.deinitialise()
    }
    
    func test_weatherapi_currentWeather_byLocation() throws {
        let expectation = XCTestExpectation(description: "Wait for API Call")
        let expectedData = WeatherData.data0
        let testCase = TestCase.success(expectedData)
        MockNetworkAdapter.initialise(testCase: testCase, expectation: expectation)
        let cityLocation = Location(cityName: "Ateli")
        weatherAPI.currentWeather(for: cityLocation) { (result: Result<WeatherData, WeatherAPIError>) in
            XCTAssertEqual(expectedData, result.object)
            XCTAssertEqual(MockNetworkAdapter.requests?.service, .weather)
            XCTAssertEqual(MockNetworkAdapter.requests?.method, .get)
            XCTAssertEqual(MockNetworkAdapter.requests?.parameter, [ParameterKey.query:"Ateli"])
            XCTAssertNil(MockNetworkAdapter.requests?.header)
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func test_weatherapi_currentWeather_byLocationWithStateCode() throws {
        let expectation = XCTestExpectation(description: "Wait for API Call")
        let expectedData = WeatherData.data0
        let testCase = TestCase.success(expectedData)
        MockNetworkAdapter.initialise(testCase: testCase, expectation: expectation)
        let cityLocation = Location(cityName: "Ateli", stateCode: "Meh")
        weatherAPI.currentWeather(for: cityLocation) { (result: Result<WeatherData, WeatherAPIError>) in
            XCTAssertEqual(expectedData, result.object)
            XCTAssertEqual(MockNetworkAdapter.requests?.service, .weather)
            XCTAssertEqual(MockNetworkAdapter.requests?.method, .get)
            XCTAssertEqual(MockNetworkAdapter.requests?.parameter, [ParameterKey.query:"Ateli,Meh"])
            XCTAssertNil(MockNetworkAdapter.requests?.header)
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func test_weatherapi_currentWeather_byLocationWithStateCodeCountryCode() throws {
        let expectation = XCTestExpectation(description: "Wait for API Call")
        let expectedData = WeatherData.data0
        let testCase = TestCase.success(expectedData)
        MockNetworkAdapter.initialise(testCase: testCase, expectation: expectation)
        let cityLocation = Location(cityName: "Ateli", stateCode: "Meh", coutryCode: "IND")
        weatherAPI.currentWeather(for: cityLocation) { (result: Result<WeatherData, WeatherAPIError>) in
            XCTAssertEqual(expectedData, result.object)
            XCTAssertEqual(MockNetworkAdapter.requests?.service, .weather)
            XCTAssertEqual(MockNetworkAdapter.requests?.method, .get)
            XCTAssertEqual(MockNetworkAdapter.requests?.parameter, [ParameterKey.query:"Ateli,Meh,IND"])
            XCTAssertNil(MockNetworkAdapter.requests?.header)
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func test_weatherapi_currentWeather_byCityId() throws {
        let expectation = XCTestExpectation(description: "Wait for API Call")
        let expectedData = WeatherData.data0
        let testCase = TestCase.success(expectedData)
        MockNetworkAdapter.initialise(testCase: testCase, expectation: expectation)
        weatherAPI.currentWeather(for: 1278223) { (result: Result<WeatherData, WeatherAPIError>) in
            XCTAssertEqual(expectedData, result.object)
            XCTAssertEqual(MockNetworkAdapter.requests?.service, .weather)
            XCTAssertEqual(MockNetworkAdapter.requests?.method, .get)
            XCTAssertEqual(MockNetworkAdapter.requests?.parameter, [ParameterKey.cityID:"1278223"])
            XCTAssertNil(MockNetworkAdapter.requests?.header)
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func test_weatherapi_currentWeather_byCoardinates() throws {
        let expectation = XCTestExpectation(description: "Wait for API Call")
        let expectedData = WeatherData.data0
        let testCase = TestCase.success(expectedData)
        MockNetworkAdapter.initialise(testCase: testCase, expectation: expectation)
        weatherAPI.currentWeather(for: Coordinates(latitude: 28.1,
                                                   logitude: 76.2833)) { (result: Result<WeatherData, WeatherAPIError>) in
            XCTAssertEqual(expectedData, result.object)
            XCTAssertEqual(MockNetworkAdapter.requests?.service, .weather)
            XCTAssertEqual(MockNetworkAdapter.requests?.method, .get)
            XCTAssertEqual(MockNetworkAdapter.requests?.parameter, [ParameterKey.logitude:"76.2833",
                                                                    ParameterKey.latitude: "28.1"])
            XCTAssertNil(MockNetworkAdapter.requests?.header)
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func test_weatherapi_currentWeather_byZipCode() throws {
        let expectation = XCTestExpectation(description: "Wait for API Call")
        let expectedData = WeatherData.data0
        let testCase = TestCase.success(expectedData)
        MockNetworkAdapter.initialise(testCase: testCase, expectation: expectation)
        weatherAPI.currentWeather(with: "AT", countryCode: "IN") { (result: Result<WeatherData, WeatherAPIError>) in
            XCTAssertEqual(expectedData, result.object)
            XCTAssertEqual(MockNetworkAdapter.requests?.service, .weather)
            XCTAssertEqual(MockNetworkAdapter.requests?.method, .get)
            XCTAssertEqual(MockNetworkAdapter.requests?.parameter, [ParameterKey.zip:"AT,IN"])
            XCTAssertNil(MockNetworkAdapter.requests?.header)
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func test_weatherapi_configuration() throws {
        XCTAssertEqual(Configuration.current.appAPIkey, "fae7190d7e6433ec3a45285ffcf55c86")
        XCTAssertEqual(Configuration.current.baseURL, "http://api.openweathermap.org/data/2.5")
    }
}
