//
//  HomeViewControllerTest.swift
//  NeatoSurfingSpotsTests
//
//  Created by Fabio Nisci on 27/04/22.
//

import XCTest
import FNEasyBind
@testable import NeatoSurfingSpots

class HomeViewControllerTest: XCTestCase {

    var sut: HomeViewController!

    override func setUp() {
        sut = makeSUT()
    }
    
    override func tearDown() {
        executeRunLoop() //fixes the memory problem when a UIWindow is used
        sut = nil
        super.tearDown()
    }

    private func makeSUT() -> HomeViewController {
        let service = NetworkServiceMock()
        let homeVM = HomeViewModel(service: service)
        let sut = HomeViewController(viewModel: homeVM)
        let window = UIWindow()
        window.addSubview(sut.view) //for .isFirstResponder/Hierarchy testing
        sut.loadViewIfNeeded()
        return sut
    }
    
    func executeRunLoop() {
        RunLoop.current.run(until: Date())
    }

    func test_viewDidload_loadEmpty() {

        XCTAssertNotNil(sut.homeViewModel, "home view model nil")
        XCTAssertEqual(sut.title, "Surfing Spots")
        XCTAssertNotNil(sut.dataSource, "data source nil")
        XCTAssertNotNil(sut.tableView, "table nil")
        XCTAssertEqual(sut.numberOfCities(), 0)
    }
    func test_setupViews() {
        sut.view.subviews.forEach { view in
            XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints, "no able to activate contraints")
        }
        XCTAssertTrue(sut.view.subviews.contains(sut.tableView), "no table view added")
//        XCTAssertGreaterThan(sut.cellFor(for: 0)!.frame.size.height, 0)
    }
    
    func test_no_row_should_be_selectable() {
        XCTAssertNil(sut.tableView.indexPathForSelectedRow)
        sut.selectCity(for: 0)
        XCTAssertNil(sut.tableView.indexPathForSelectedRow)
    }
    
    func test_sections_and_cities() {
        sut.homeViewModel.fetchCities()
        sut.applySnapshot(items: sut.homeViewModel.cities.value ?? [], animatingDifferences: false)
        let numberOfSections = sut.dataSource.numberOfSections(in: sut.tableView)
        XCTAssertEqual(numberOfSections, 1)
        
        let numberOfCities = sut.numberOfCities()
        XCTAssertEqual(numberOfCities, 1)
    }
    
//    func test_titleCell() throws {
//        sut.homeViewModel.fetchCities()
//        sut.applySnapshot(items: sut.homeViewModel.cities.value ?? [], animatingDifferences: false)
//
//        let cell = try XCTUnwrap(sut.cellFor(for: 0), "city cell is nil")
//        XCTAssertEqual(cell.cityTitle.text, "Napoli")
//        XCTAssertEqual(cell.cityWeather.text, "Cloudy - 9 degree")
//        XCTAssertNotNil(cell.cityImageView.image, "city image is nil")
//    }

}

private extension HomeViewController {
    func numberOfCities() -> Int {
        return self.dataSource.snapshot().numberOfItems(inSection: .main)
    }
    func cellFor(for row: Int, section: Int = 0) -> CityCell? {
        let indexPath = IndexPath(row: row, section: section)
        return self.dataSource.tableView(self.tableView, cellForRowAt: indexPath) as? CityCell
    }
    func selectCity(for row: Int, section: Int = 0) {
        let indexPath = IndexPath(row: row, section: section)
        self.tableView.delegate?.tableView?(self.tableView, didSelectRowAt: indexPath)
    }
    func spinnerView() throws -> UIView? {
        return self.tableView.tableFooterView
    }
    
//    func executeRunLoop() {
//        RunLoop.current.run(until: Date())
//    }
}
