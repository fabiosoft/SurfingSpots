//
//  NeatoSurfingSpotsTests.swift
//  NeatoSurfingSpotsTests
//
//  Created by Fabio Nisci on 25/03/22.
//

import XCTest
@testable import NeatoSurfingSpots

class NeatoSurfingSpotsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// test the home page title
    func testHomeVMTitle() {
        let homeVM = HomeViewModel()
        XCTAssertEqual(homeVM.title, "Surfing Spots")
    }

    /// test requested cities
    func testFetchCities() {
        let exp = expectation(description: "wait for cities")

        let mockyOutput = ["cities": [
            City(name: "Cuba"),
            City(name: "Los Angeles"),
            City(name: "Miami"),
            City(name: "Porto"),
            City(name: "Ortona"),
            City(name: "Riccione"),
            City(name: "Midgar")
        ]]

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let mockyData = try! encoder.encode(mockyOutput)
        MockyURLProtocol.testURLs = [
            URL(string: "https://run.mocky.io/v3/652ceb94-b24e-432b-b6c5-8a54bc1226b6")!: mockyData
        ]
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockyURLProtocol.self]
        let session = URLSession(configuration: config)
        let network = NetworkClient(session: session)
        network.cities { result in
            switch result {
            case .success(let cities):
                XCTAssertEqual(cities.count, mockyOutput["cities"]!.count)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 3)
    }

    /// test fetched random number
    func testFetchRandomNumber() {
        let exp = expectation(description: "wait for number")

        let mockyOutput = "2161 is a prime factor of 111111111111111111111111111111."
        let mockyData = mockyOutput.data(using: .utf8)!
        MockyURLProtocol.testURLs = [
            URL(string: "http://numbersapi.com/random/math")!: mockyData
        ]
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockyURLProtocol.self]
        let session = URLSession(configuration: config)
        let network = NetworkClient(session: session)
        network.randomNumber { result in
            switch result {
            case .success(let number):
                XCTAssertEqual(number, 2161 / 100)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 3)
    }

    /// test sunny, skyline image according to temperature
    func testCityViewModel() {
        let cityName = "napoli"
        let city = City(name: cityName)
        let cityVM = CityViewModel(city)
        XCTAssertEqual(cityVM.displayName, "Napoli")
        cityVM.temperature.onNext(value: 31)
        XCTAssertTrue(cityVM.isSunny)
        XCTAssertNotNil(cityVM.skyline())
        cityVM.temperature.onNext(value: 29)
        XCTAssertFalse(cityVM.isSunny)
    }

}
