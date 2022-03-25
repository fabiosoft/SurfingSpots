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

    func testHomeVMTitle() {
        let homeVM = HomeViewModel()
        XCTAssertEqual(homeVM.title, "Surfing Spots")
    }

    func testFetchCities() {
        let exp = XCTestExpectation()
        let network = NetworkClientMock()
        let perPage = 3
        network.cities { result in
            switch result {
            case .success(let cities):
                XCTAssertEqual(cities.count, perPage)
                XCTAssertGreaterThan(cities.first!.temperature, -1) // random temp > 0
            case .failure(let error):
                XCTAssertNotNil(error)

                exp.fulfill()
            }
        }
    }

}
