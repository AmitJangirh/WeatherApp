//
//  HomeViewController.swift
//  Weather-iOS
//
//  Created by Amit Jangirh on 12/06/21.
//

import UIKit

class HomeViewController: UIViewController, StoryboardGettable {
    // MARK: - Constant
    struct Constant {
        static let title = "Home"
        static let addButtonTitle = "+"
        static let rowHeight: CGFloat = 50
    }
    
    // MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var addButton: UIButton!
    @IBOutlet private var noContentLabel: UILabel!
    
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
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Theme.Color.tintColor]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: Theme.Color.tintColor]
        self.navigationController?.navigationBar.barTintColor = Theme.Color.greyColor
        self.navigationController?.navigationBar.backgroundColor = Theme.Color.greyColor
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
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
    }
    
    private func refreshNoContentLabel() {
        noContentLabel.isHidden = viewModel.isNoContentHidden
        noContentLabel.text = "Please Add Location"
    }
    
    private func refreshData() {
        DispatchQueue.main.async {
            self.refreshNoContentLabel()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Fetch Data
    private func fetchData() {
        viewModel.fetchData()
        refreshData()
        
    }
    
    // MARK: - IBAction
    @IBAction func addButtonAction(sender: UIButton) {
        // Open Map View to add new location
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
        guard let cell = HomeTableViewCell.dequeueCell(for: tableView, indexPath: indexPath),
              let data = viewModel[indexPath] else {
            return UITableViewCell()
        }
        let cellData = HomeTableViewCellViewModel(data: data)
        cell.configure(with: cellData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
