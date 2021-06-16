//
//  SearchCityViewController.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 15/06/21.
//

import Foundation
import UIKit

protocol SelectedCityData {
    var cityName: String { get set }
    var cityId: UInt { get set }
    var latitude: Double { get set }
    var longitude: Double { get set }
}

protocol SearchCityViewControllerDelegate: class {
    func didSelect(selectedCity: SelectedCityData)
}

class SearchCityViewController: UIViewController, StoryboardGettable {
    // MARK: - Constant
    struct Constant {
        static let title = "Search City"
        static let cellIdentifier = "SearchTableViewCellIdentifier"
        static let rowHeight: CGFloat = 64
    }
    
    // MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var searchBar: UISearchBar!
    lazy private var loadingView: UIView = {
        let baseView = UIView(frame: self.view.bounds)
        baseView.backgroundColor = Theme.Color.dimBackgroundColor
        let activityView = UIActivityIndicatorView(frame: baseView.bounds)
        activityView.startAnimating()
        baseView.addSubview(activityView)
        self.view.addSubview(baseView)
        return baseView
    }()
    var cancelBatItem: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .cancel,
                        target: self,
                        action: #selector(cancelIconDidPress))
    }

    // MARK: Var
    var viewModel = SearchViewModel()
    weak var delegate: SearchCityViewControllerDelegate?
        
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadData()
    }
    
    private func setup() {
        setupViewController()
        setupTableView()
        setupSearchBar()
    }
    
    private func setupViewController() {
        self.title = Constant.title
        self.setupCommonNavigation()
        // Drop Shadow
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // Setup right bar button icon
        self.navigationItem.rightBarButtonItem = cancelBatItem
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = false
        tableView.estimatedRowHeight = Constant.rowHeight
        tableView.rowHeight = Constant.rowHeight
        tableView.tableFooterView = UIView()
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constant.cellIdentifier)
    }
    
    private func setupSearchBar() {
        searchBar.barTintColor = Theme.Color.greyColor
        searchBar.tintColor = Theme.Color.tintColor
        searchBar.delegate = self
        let searchTextField = searchBar.searchTextField
        searchTextField.textColor = Theme.Color.greyColor
        searchTextField.tintColor = Theme.Color.greyColor
        searchTextField.clearButtonMode = .always
        searchTextField.backgroundColor = Theme.Color.tintColor
        if let glassIconView = searchTextField.leftView as? UIImageView {
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = Theme.Color.greyColor
        }
    }
    
    // MARK: - Action
    @objc func cancelIconDidPress() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func loadData() {
        self.setShowLoading(show: true)
        viewModel.loadData { [weak self] in
            self?.setShowLoading(show: false)
        }
    }
    
    private func setShowLoading(show: Bool) {
        loadingView.frame = self.view.frame
        loadingView.isHidden = !show
    }
}

// MARK: - Searching
extension SearchCityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(text: searchText)
    }
    
    private func search(text: String) {
        viewModel.search(cityName: text) { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - TableviewDataSource
extension SearchCityViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowsCount(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: Constant.cellIdentifier)
        }
        let searchData = viewModel[indexPath]
        cell?.textLabel?.text = searchData.cityName
        cell?.textLabel?.textColor = Theme.Color.darkColor
        cell?.textLabel?.font = Theme.Font.mediumFont18
        cell?.detailTextLabel?.text = searchData.subText
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchData = viewModel[indexPath]
        struct SelectedCity: SelectedCityData {
            var cityName: String
            var cityId: UInt
            var latitude: Double
            var longitude: Double
        }
        let selectedCity = SelectedCity(cityName: searchData.cityName,
                                        cityId: searchData.cityId,
                                        latitude: searchData.coordinates.latitude,
                                        longitude: searchData.coordinates.longitude)
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.didSelect(selectedCity: selectedCity)
        }
    }
}
