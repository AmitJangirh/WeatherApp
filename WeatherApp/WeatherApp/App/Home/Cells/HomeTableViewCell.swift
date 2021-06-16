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
    var decription: String
    var iconURL: String?
}

class HomeTableViewCell: UITableViewCell, TableCellAdaptable {
    typealias CellData = HomeTableViewCellViewModel

    // MARK: - IBOutlet
    @IBOutlet private var cityNameLabel: UILabel! {
        didSet {
            self.cityNameLabel.font = Theme.Font.boldLargeFont32
            self.cityNameLabel.textColor = Theme.Color.greyColor
        }
    }
    @IBOutlet private var tempLabel: UILabel! {
        didSet {
            self.tempLabel.font = Theme.Font.mediumFont18
            self.tempLabel.textColor = Theme.Color.greyColor
        }
    }
    @IBOutlet private var descriptionLabel: UILabel! {
        didSet {
            self.descriptionLabel.font = Theme.Font.mediumFont18
            self.descriptionLabel.textColor = Theme.Color.greyColor
        }
    }
    @IBOutlet private var weatherIconImageView: UIImageView!
  
    
    // MARK: - Configure
    func configure(with data: HomeTableViewCellViewModel) {
        self.tempLabel.text = data.temperature
        self.cityNameLabel.text = data.cityName
        self.descriptionLabel.text = data.decription
    }
}
