//
//  CityViewModelTests.swift
//  NeatoSurfingSpotsTests
//
//  Created by Fabio Nisci on 01/05/22.
//

import XCTest
@testable import NeatoSurfingSpots

class CityViewModelTests: XCTestCase {

    var sut: CityViewModel!
    var city: City!
    
    override func setUp() {
        sut = makeSUT()
    }
    
    override func tearDown() {
        sut = nil
        city = nil
    }

    private func makeSUT() -> CityViewModel {
        let service = NetworkServiceMock()
        city = City(name: "Napoli")
        let sut = CityViewModel(city, network: service)
        return sut
    }
    
    func test_displayname_equals_cityName() {
        XCTAssertEqual(sut.displayName, city.name)
    }
    
    func test_sunny_changes_according_to_temperature() {
        sut.temperature.onNext(value: 20)
        XCTAssertFalse(sut.isSunny)
        sut.temperature.onNext(value: 30)
        XCTAssertTrue(sut.isSunny)
    }
    
    func test_weathercondition_output() {
        sut.temperature.onNext(value: 20)
        XCTAssertEqual(sut.weatherConditions(), "Cloudy - 20 degree")
        sut.temperature.onNext(value: 30)
        XCTAssertEqual(sut.weatherConditions(), "Sunny - 30 degree")
    }
    
    func test_emptyCityname_description() {
        let service = NetworkServiceMock()
        city = City(name: nil)
        let sut = CityViewModel(city, network: service)
        sut.temperature.onNext(value: 7)
        XCTAssertEqual(sut.description, "nowhere 7 degree")
        XCTAssertEqual(sut.description, sut.debugDescription)
    }
 
    func test_skylineImage() {
        sut.temperature.onNext(value: 20)
        XCTAssertNil(sut.skyline(), "cloudy image should not be available")
        sut.temperature.onNext(value: 30)
        XCTAssertNotNil(sut.skyline(), "sunny image should be available")
    }

}
