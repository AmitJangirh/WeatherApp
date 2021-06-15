//
//  HomeTableViewCell.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 14/06/21.
//

import Foundation
import UIKit

struct HomeTableViewCellViewModel {
    var temperature: String
    var cityName: String
}

class HomeTableViewCell: UITableViewCell, TableCellAdaptable {
    typealias CellData = HomeTableViewCellViewModel

    // MARK: - IBOutlet
    @IBOutlet private var tempLabel: UILabel! {
        didSet {
            self.tempLabel.font = Theme.Font.largeFont32
            self.tempLabel.textColor = Theme.Color.greyColor
        }
    }
    @IBOutlet private var cityNameLabel: UILabel! {
        didSet {
            self.cityNameLabel.font = Theme.Font.largeFont32
            self.cityNameLabel.textColor = Theme.Color.greyColor
        }
    }
    
    // MARK: - Configure
    func configure(with data: HomeTableViewCellViewModel) {
        self.tempLabel.text = data.temperature
        self.cityNameLabel.text = data.cityName
    }
}
