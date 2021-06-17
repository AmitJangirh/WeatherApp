//
//  HomeViewController.swift
//  Weather-iOS
//
//  Created by Amit Jangirh on 12/06/21.
//

import UIKit
import WeatherAPI

class HomeViewController: UIViewController, StoryboardGettable {
    // MARK: - Constant
    struct Constant {
        static let title = "Home"
        static let addButtonTitle = "+"
        static let rowHeight: CGFloat = 100
        static let noContentText = "Please Add Location"
    }
    
    // MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var addButton: UIButton!
    @IBOutlet private var noContentLabel: UILabel!
    private var editBarItem: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .edit,
                        target: self,
                        action: #selector(editIconDidPress))
    }
    private var doneBarItem: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .done,
                        target: self,
                        action: #selector(editIconDidPress))
    }

    // MARK: - Vars
    var viewModel = HomeViewModel()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        refreshData()
        fetchData()
    }
    
    private func setup() {
        setupViewController()
        setupTableView()
        setupAddButton()
        refreshNoContentLabel()
    }
    
    private func setupViewController() {
        self.title = Constant.title
        self.setupCommonNavigation()
        // Setup right bar button icon
        self.navigationItem.rightBarButtonItem = editBarItem
    }
    
    private func setupTableView() {
        tableView.allowsMultipleSelection = false
        tableView.estimatedRowHeight = Constant.rowHeight
        tableView.rowHeight = Constant.rowHeight
        tableView.tableFooterView = UIView()
        HomeTableViewCell.register(for: tableView)
    }
    
    private func setupAddButton() {
        addButton.setTitle(Constant.addButtonTitle, for: .normal)
        addButton.layer.cornerRadius = addButton.bounds.height/2
        addButton.backgroundColor = Theme.Color.greyColor
        addButton.setTitleColor(Theme.Color.tintColor, for: .normal)
        addButton.titleLabel?.font = Theme.Font.largeFont32
    }
    
    private func refreshNoContentLabel() {
        noContentLabel.text = Constant.noContentText
        noContentLabel.isHidden = viewModel.haveContent
        editButtonItem.isEnabled = viewModel.haveContent
    }
    
    private func refreshData() {
        DispatchQueue.main.async {
            self.refreshNoContentLabel()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Fetch Data
    private func fetchData() {
        viewModel.fetchData(completion: {
            self.refreshData()
        })
    }
    
    // MARK: - IBAction
    @IBAction func addButtonAction(sender: UIButton) {
        // Open Map View to add new location
        let addVC = AddCityViewController.getVC()
        addVC.delegate = self
        self.navigationController?.show(addVC, sender: self)
    }
    
    @objc
    func editIconDidPress() {
        tableView.isEditing = !tableView.isEditing
        let rightBarButtonItem = tableView.isEditing ? doneBarItem : editBarItem
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
        tableView.reloadData()
    }
    
    private func handleDelete(for indexPath: IndexPath) {
        viewModel.deleteItem(at: indexPath) { [weak self] in
            self?.refreshData()
        }
    }
}

extension HomeViewController: AddCityViewControllerDelegate {
    func addCity(cityData: AddCityData) {
        viewModel.addCity(addCity: cityData) { [weak self] in
            self?.refreshData()
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowsCount(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = HomeTableViewCell.dequeueCell(for: tableView, indexPath: indexPath) else {
            return UITableViewCell()
        }
        let storeData = viewModel[cellViewModel: indexPath]
        cell.configure(with: storeData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let apiData = viewModel[apiData: indexPath] else {
            return
        }
        let selectedCity = SelectedCityData(weatherData: apiData)
        let cityDetailVC = CityDetailViewController.getVC()
        cityDetailVC.viewModel = CityDetailViewModel(data: selectedCity)
        self.navigationController?.show(cityDetailVC, sender: self)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            handleDelete(for: indexPath)
        }
    }
}

struct SelectedCityData: CityDetailData {
    var temperature: Double
    var minTemperature: Double
    var maxTemperature: Double
    var pressure: Double
    var humidity: Int
    var visibility: Int
    var weatherDescription: String
    var weatherIcon: String
    var windSpeed: Double
    var windDegree: Int
    var cloudiness: Int
    var cityId: Int
    var cityName: String
    
    init(weatherData: WeatherData) {
        self.temperature = weatherData.main?.temp ?? 0
        self.minTemperature = weatherData.main?.minTemperature ?? 0
        self.maxTemperature = weatherData.main?.maxTemperature ?? 0
        self.pressure = weatherData.main?.pressure ?? 0
        self.humidity = weatherData.main?.humidity ?? 0
        self.visibility = weatherData.visibility ?? 0
        self.weatherDescription = weatherData.weather?.description ?? ""
        self.weatherIcon = weatherData.weather?.first?.icon ?? ""
        self.windSpeed = weatherData.wind?.speed ?? 0
        self.windDegree = weatherData.wind?.degree ?? 0
        self.cloudiness = weatherData.clouds?.all ?? 0
        self.cityId = weatherData.id ?? 0
        self.cityName = weatherData.name ?? ""
    }
}
