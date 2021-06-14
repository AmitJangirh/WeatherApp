//
//  HomeViewController.swift
//  Weather-iOS
//
//  Created by Amit Jangirh on 12/06/21.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - Constant
    struct Constant {
        static let title = "Home"
        static let addButtonTitle = "+"
        static let rowHeight: CGFloat = 50
    }
    
    // MARK: - IBOutlets
    @IBOutlet private var addButton: UIButton!
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Vars
    var viewModel = HomeViewModel()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupViewController()
        setupTableView()
        setupAddButton()
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
    }
    
    private func setupAddButton() {
        addButton.setTitle(Constant.addButtonTitle, for: .normal)
    }
    
    // MARK: - IBAction
    @IBAction func addButtonAction(sender: UIButton) {
        
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
