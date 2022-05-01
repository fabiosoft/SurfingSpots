//
//  NeatoSurfingSpotsTests.swift
//  NeatoSurfingSpotsTests
//
//  Created by Fabio Nisci on 25/03/22.
//

import XCTest
@testable import NeatoSurfingSpots

class CityTests: XCTestCase {
    func testCityName() {
        let city = City(name: "Napoli")
        XCTAssertEqual(city.name, "Napoli")
    }
    
    func testSurfingSpotElems() {
        let city = City(name: "Napoli")
        let cities = SurfingSpot(cities: [city])
        XCTAssertEqual(cities.cities?.count, 1)
    }
}

class HomeViewModelTests: XCTestCase {
    
    var sut: HomeViewModel!
    
    override func setUp() {
        sut = makeSUT()
    }
    
    override func tearDown() {
        sut = nil
    }

    private func makeSUT() -> HomeViewModel {
        let service = NetworkServiceMock()
        let sut = HomeViewModel(service: service)
        return sut
    }

    /// test the home page title
    func testHomeVMTitle() {
        XCTAssertEqual(sut.title, "Surfing Spots")
    }
    
    func test_fetching_status() throws {
        let isFetchingSpy = SpyTest(sut.isfetching)
        XCTAssertEqual(isFetchingSpy.values, [false])
        sut.fetchCities()
        XCTAssertEqual(isFetchingSpy.values, [false, true, false])
    }

    /// test requested cities
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
    
    func testSortingPredicate() {
        XCTAssertTrue(sut.sortPredicate(30, 20))
        XCTAssertFalse(sut.sortPredicate(20, 30))
        let nilValue: Int? = nil
        XCTAssertFalse(sut.sortPredicate(nilValue, nilValue))
    }

    /// test sunny, skyline image according to temperature
//    func testCityViewModel() {
//        let city = City(name: "Napoli")
//        let cityVM = CityViewModel(city)
//        XCTAssertEqual(cityVM.displayName, "Napoli")
//        cityVM.temperature.onNext(value: 31)
//        XCTAssertTrue(cityVM.isSunny)
//        XCTAssertNotNil(cityVM.skyline())
//        cityVM.temperature.onNext(value: 29)
//        XCTAssertFalse(cityVM.isSunny)
//    }
}
