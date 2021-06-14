//
//  HomeViewControllerTests.swift
//  WeatherAppTests
//
//  Created by Amit Jangirh on 14/06/21.
//

import XCTest
@testable import WeatherApp

class HomeViewControllerTests: XCTestCase {
    var homeVC: HomeViewController!
    var mockNavigationVC: UINavigationController!
    var tableView: UITableView!

    override func tearDownWithError() throws {
        homeVC = nil
        tableView = nil
        mockNavigationVC = nil
    }
    
    func test_tableView_withNoData_shouldShowOneRow() {
        // Setup
        setupSUT(with: [])
        // Actions
        let sections = homeVC.numberOfSections(in: tableView)
        let rows = homeVC.tableView(tableView, numberOfRowsInSection: 0)
        let mirrorVC = ViewControllerMirror(viewController: homeVC)
        let noContentLabel = try! XCTUnwrap(mirrorVC.noContentLabel)
        // Tests
        XCTAssertEqual(homeVC.title, "Home")
        XCTAssertEqual(sections, 1)
        XCTAssertEqual(rows, 1)
        XCTAssertFalse(noContentLabel.isHidden)
        XCTAssertEqual(noContentLabel.text, "Please Add Location")
    }
    
    func test_tableView_withData_shouldShowData() {
        // Setup
        setupSUT(with: [])
        // Actions
        let sections = homeVC.numberOfSections(in: tableView)
        let rows = homeVC.tableView(tableView, numberOfRowsInSection: 0)
        let mirrorVC = ViewControllerMirror(viewController: homeVC)
        let noContentLabel = try! XCTUnwrap(mirrorVC.noContentLabel)
        // Tests
        XCTAssertEqual(homeVC.title, "Home")
        XCTAssertEqual(sections, 1)
        XCTAssertEqual(rows, 1)
        XCTAssertFalse(noContentLabel.isHidden)
        XCTAssertEqual(noContentLabel.text, "Please Add Location")
    }
}

// MARK: - Utilites
extension HomeViewControllerTests {
    private func setupSUT(with dataArray: [Any]) {
        homeVC = HomeViewController.getVC()
        homeVC.viewModel = HomeViewModel(dataArray: dataArray)
        mockNavigationVC = MockNavigationController(rootViewController: homeVC)
        homeVC.loadViewIfNeeded()
        tableView = getTableView(homeVC)
    }
    
    private func getTableView(_ fromVC: HomeViewController) -> UITableView {
        let mirrorVC = ViewControllerMirror(viewController: fromVC)
        return try! XCTUnwrap(mirrorVC.tableView)
    }
    
    private func createCellMirror(at indexPath: IndexPath) -> TableViewCellMirror {
        let cell = homeVC.tableView(tableView, cellForRowAt: indexPath)
        return TableViewCellMirror(cell: cell)
    }
}

extension ViewControllerMirror {
    fileprivate var tableView: UITableView? { extract() }
    fileprivate var addButton: UIButton? { extract() }
    fileprivate var noContentLabel: UILabel? { extract() }
}

extension TableViewCellMirror {
    var titleLabel: UILabel? { extract() }
    var cityNameLabel: UILabel? { extract() }
    var tempLabel: UILabel? { extract() }
}
