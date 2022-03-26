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
        let exp = XCTestExpectation()
        let network = NetworkClientMock()
        let perPage = 3
        network.cities { result in
            switch result {
            case .success(let cities):
                XCTAssertEqual(cities.count, perPage)
            case .failure(let error):
                XCTAssertNotNil(error)

                exp.fulfill()
            }
        }
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
    func testCityViewModel() {
        let city = City(name: "Napoli")
        let cityVM = CityViewModel(city)
        XCTAssertEqual(cityVM.displayName, "Napoli")
        cityVM.temperature.onNext(value: 31)
        XCTAssertTrue(cityVM.isSunny)
        XCTAssertNotNil(cityVM.skyline())
        cityVM.temperature.onNext(value: 29)
        XCTAssertFalse(cityVM.isSunny)
    }

}
