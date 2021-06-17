//
//  CityDetailViewController.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 17/06/21.
//

import Foundation
import UIKit

class CityDetailViewController: UIViewController, StoryboardGettable {
    // MARK: - Constant
    struct Constant {
        static let rowHeight: CGFloat = 120
    }
    
    // MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Vars
    var viewModel = CityDetailViewModel(data: NoData())
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupViewController()
        setupTableView()
    }
    
    private func setupViewController() {
        self.title = viewModel.title
        self.setupCommonNavigation()
    }
    
    private func setupTableView() {
        tableView.allowsMultipleSelection = false
        tableView.estimatedRowHeight = Constant.rowHeight
        tableView.rowHeight = Constant.rowHeight
        tableView.tableFooterView = UIView()
        CityDetailCell.register(for: tableView)
    }
}

extension CityDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowsCount(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = CityDetailCell.dequeueCell(for: tableView, indexPath: indexPath) else {
            return UITableViewCell()
        }
//        let storeData = viewModel[indexPath]
//        cell.configure(with: storeData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
