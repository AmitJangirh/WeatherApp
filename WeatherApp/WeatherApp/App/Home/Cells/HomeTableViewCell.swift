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
    
    init(data: CityWeatherData) {
        self.temperature = data.temperature
        self.cityName = data.cityName
    }
}

class HomeTableViewCell: UITableViewCell, TableCellAdaptable {
    typealias CellData = HomeTableViewCellViewModel

    // MARK: - IBOutlet
    @IBOutlet private var tempLabel: UILabel! {
        didSet {
            self.tempLabel.font = Theme.Font.largeFont32
            self.tempLabel.textColor = Theme.Color.tintColor
        }
    }
    @IBOutlet private var cityNameLabel: UILabel! {
        didSet {
            self.cityNameLabel.font = Theme.Font.largeFont32
            self.cityNameLabel.textColor = Theme.Color.tintColor
        }
    }
    
    // MARK: - Configure
    func configure(with data: HomeTableViewCellViewModel) {
        self.tempLabel.text = data.temperature
        self.cityNameLabel.text = data.cityName
    }
}
