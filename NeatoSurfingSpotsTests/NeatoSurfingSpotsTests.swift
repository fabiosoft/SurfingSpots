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
    func testFetchCities() {
        let citiesSpy = SpyTestSequence(sut.cities)
        XCTAssertEqual(citiesSpy.values.count, 0)
        sut.fetchCities()
        XCTAssertEqual(citiesSpy.values.count, 1)
        sut.isfetching.onNext(value: true)
        sut.fetchCities()
        XCTAssertEqual(citiesSpy.values.count, 1) //it's already fetching
    }
    
    func testFetchCitiesFails() {
        let citiesSpy = SpyTestSequence(sut.cities)
        let service = NetworkServiceMock()
        service.result = .failure(NetworkError.networkError)
        let sut = HomeViewModel(service: service)
        sut.fetchCities()
        XCTAssertEqual(citiesSpy.values.count, 0)
    }
    
    func testSortingPredicate() {
        XCTAssertTrue(sut.sortPredicate(30, 20))
        XCTAssertFalse(sut.sortPredicate(20, 30))
        let nilValue: Int? = nil
        XCTAssertFalse(sut.sortPredicate(nilValue, nilValue))
    }

    /// test fetched random number
    func testFetchRandomNumber() {
        let exp = XCTestExpectation()
        let network = NetworkClientMock()
        network.randomNumber = 42
        network.randomNumber { result in
            switch result {
            case .success(let number):
                XCTAssertEqual(number, 42)
            case .failure(let error):
                XCTAssertNotNil(error)

                exp.fulfill()
            }
        }
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
