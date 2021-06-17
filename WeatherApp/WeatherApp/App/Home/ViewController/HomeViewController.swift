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
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var addButton: UIButton!
    @IBOutlet private var noContentLabel: UILabel!
    // Getters
    private var editBarItem: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .edit,
                        target: self,
                        action: #selector(editIconDidPress))
    }
    private var settingBarItem: UIBarButtonItem {
        UIBarButtonItem(image: UIImage.getImage(imageName: .settingIcon),
                        style: .plain,
                        target: self,
                        action: #selector(settingIconDidPress))
    }
    private var doneBarItem: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .done,
                        target: self,
                        action: #selector(editIconDidPress))
    }
    private var deleteBarItem: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .trash,
                        target: self,
                        action: #selector(deleteIconDidPress))
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
        setEditing(isEditing: false)
    }
    
    private func setupTableView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = viewModel.sizeOfItem(at: IndexPath(row: 0, section: 0))
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.allowsMultipleSelection = false
        HomeCollectionViewCell.register(for: collectionView)
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
            self.collectionView.reloadData()
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
        viewModel.isEditing = !viewModel.isEditing
        setEditing(isEditing: viewModel.isEditing)
    }
    
    private func setEditing(isEditing: Bool) {
        self.collectionView.allowsMultipleSelection = isEditing
        let rightBarButtonItem = isEditing ? deleteBarItem : settingBarItem
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
        let leftBarButtonItem = isEditing ? doneBarItem : editBarItem
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
        collectionView.reloadData()
    }
    
    @objc func settingIconDidPress() {
        let settingVC = SettingViewController.getVC()
        self.navigationController?.show(settingVC, sender: self)
    }
    
    @objc func deleteIconDidPress() {
        guard let selectedIndexPath = collectionView.indexPathsForSelectedItems else {
            return
        }
        viewModel.deleteItems(at: selectedIndexPath) { [weak self] in
            self?.refreshData()
        }
    }
    
    private func navigationToDetailPage(for indexPath: IndexPath) {
        guard let apiData = viewModel[apiData: indexPath] else {
            return
        }
        let selectedCity = CityDetailData(weatherData: apiData)
        let cityDetailVC = CityDetailViewController.getVC()
        cityDetailVC.viewModel = CityDetailViewModel(data: selectedCity)
        self.navigationController?.show(cityDetailVC, sender: self)
    }
}

extension HomeViewController: AddCityViewControllerDelegate {
    func addCity(cityData: AddCityData) {
        viewModel.addCity(addCity: cityData) { [weak self] in
            self?.refreshData()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sectionCount()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.rowsCount(for: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = HomeCollectionViewCell.dequeueCell(for: collectionView, indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        let storeData = viewModel[cellViewModel: indexPath]
        cell.configure(with: storeData, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.isEditing {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        } else {
            navigationToDetailPage(for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeOfItem(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return viewModel.insetForSectionAt(at: section)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.insetForSectionAt(at: section).left
    }
}
