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
    var collectionView: UICollectionView!

    override func tearDownWithError() throws {
        homeVC = nil
        collectionView = nil
        mockNavigationVC = nil
    }
    
    func test_tableView_withNoData_shouldShowOneRow() {
        // Setup
        setupSUT(with: MockStorageFetcher())
        // Actions
        let sections = homeVC.numberOfSections(in: collectionView)
        let rows = homeVC.collectionView(collectionView, numberOfItemsInSection: 0)
        let mirrorVC = ViewControllerMirror(viewController: homeVC)
        let noContentLabel = try! XCTUnwrap(mirrorVC.noContentLabel)
        // Tests
        XCTAssertEqual(homeVC.title, "Home")
        XCTAssertEqual(sections, 1)
        XCTAssertEqual(rows, 0)
        XCTAssertFalse(noContentLabel.isHidden)
        XCTAssertEqual(noContentLabel.text, "Please Add Location")
    }
    
    func test_tableView_withData_shouldShowData() {
        // Setup
        setupSUT(with: MockStorageFetcher(cityWeatherData: CityWeatherStoreData.data0))
        // Actions
        let sections = homeVC.numberOfSections(in: collectionView)
        let rows = homeVC.collectionView(collectionView, numberOfItemsInSection: 0)
        // Tests
        XCTAssertEqual(homeVC.title, "Home")
        XCTAssertEqual(sections, 1)
        XCTAssertEqual(rows, 1)
    }
    
    func test_tableView_withData_shouldShowCellData() {
        // Setup
        setupSUT(with: MockStorageFetcher(cityWeatherData: CityWeatherStoreData.data0))
        // Actions
        let cell = createCellMirror(at: IndexPath(row: 0, section: 0))
        let cityNameLabel = cell.cityNameLabel!
        // Tests
        XCTAssertEqual(cityNameLabel.text, "Ateli")
    }
}

// MARK: - Utilites
extension HomeViewControllerTests {
    private func setupSUT(with mockFetcher: HomeStorageFetchable) {
        homeVC = HomeViewController.getVC()
        homeVC.viewModel = HomeViewModel(storageFetcher: mockFetcher)
        mockNavigationVC = MockNavigationController(rootViewController: homeVC)
        homeVC.loadViewIfNeeded()
        collectionView = getTableView(homeVC)
    }
    
    private func getTableView(_ fromVC: HomeViewController) -> UICollectionView {
        let mirrorVC = ViewControllerMirror(viewController: fromVC)
        return try! XCTUnwrap(mirrorVC.collectionView)
    }
    
    private func createCellMirror(at indexPath: IndexPath) -> CollectionViewCellMirror {
        let cell = homeVC.collectionView(collectionView, cellForItemAt: indexPath)
        return CollectionViewCellMirror(cell: cell)
    }
}

// MARK: - Mirror Extension
extension ViewControllerMirror {
    fileprivate var collectionView: UICollectionView? { extract() }
    fileprivate var addButton: UIButton? { extract() }
    fileprivate var noContentLabel: UILabel? { extract() }
}

extension CollectionViewCellMirror {
    var titleLabel: UILabel? { extract() }
    var cityNameLabel: UILabel? { extract() }
    var tempLabel: UILabel? { extract() }
    var descriptionLabel: UILabel? { extract() }
}
