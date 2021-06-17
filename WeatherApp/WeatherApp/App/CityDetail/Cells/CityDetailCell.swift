//
//  CityDetailCell.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 17/06/21.
//

import Foundation
import UIKit

class CityDetailCell: UITableViewCell, TableCellAdaptable {
    typealias CellData = HomeTableViewCellViewModel

    // MARK: - IBOutlet
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
            self.descriptionLabel.numberOfLines = 0
        }
    }
    @IBOutlet private var weatherIconImageView: UIImageView!
    @IBOutlet private var maxTemperature: UILabel!
    @IBOutlet private var minTemperature: UILabel!
    @IBOutlet private var windDetail: UILabel!
  
    
    // MARK: - Configure
    func configure(with data: HomeTableViewCellViewModel) {
        self.tempLabel.text = data.temperature
        self.descriptionLabel.text = data.decription
        self.setIconImage(with: data)
    }
    
    private func setIconImage(with data: HomeTableViewCellViewModel) {
        guard let icon = data.iconName else {
            self.setPlaceholderImage()
            return
        }
        UIImage.getImage(icon: icon) { [weak self] (iconImage) in
            DispatchQueue.main.async {
                self?.weatherIconImageView?.image = iconImage
            }
        }
    }
    
    private func setPlaceholderImage() {
        self.weatherIconImageView.image = UIImage.getImage(imageName: .defaultImage)
    }
}
