//
//  CityDetailCell.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 17/06/21.
//

import Foundation
import UIKit

struct CityDetailCellViewModel {
    var data: CityDetailData
    // Getters
    var temperature: String {
        return "\(data.temperature)".appendTemperatureUnit(unit: .fahrenheit)
    }
    var feelsLikeTemp: String {
        return "Feels like \(data.feelsLikeTemp)".appendTemperatureUnit(unit: .fahrenheit)
    }
    var minTemperature: String {
        "".appendUnicode(code: .downArrow) + "\(data.minTemperature)"
            .appendTemperatureUnit(unit: .fahrenheit)
    }
    var maxTemperature: String {
        "".appendUnicode(code: .upArrow) + " \(data.maxTemperature)"
            .appendTemperatureUnit(unit: .fahrenheit)
    }
    var pressure: String {
        return "Pressure: \(data.pressure)inHG"
    }
    var humidity: String {
        return "Humidity: \(data.humidity)%"
    }
    var visibility: String {
        return "Visibility: \(data.visibility)mi"
    }
    var weatherDescription: String {
        return data.weatherDescription
    }
    var weatherIcon: String {
        return data.weatherIcon
    }
    var windSpeed: String {
        return "Wind: \(data.windSpeed)mph N"
    }
    var windDegree: Int = 0
    var cloudiness: Int = 0
    var cityId: Int = 0
    var cityName: String = ""
    
    init(data: CityDetailData) {
        self.data = data
        self.cityId = data.cityId
        self.cityName = data.cityName
    }
}

class CityDetailCell: UITableViewCell, TableCellAdaptable {
    typealias CellData = CityDetailCellViewModel

    // MARK: - IBOutlet
    @IBOutlet private var tempLabel: UILabel! {
        didSet {
            self.tempLabel.font = Theme.Font.boldLargeFont32
            self.tempLabel.textColor = Theme.Color.greyColor
        }
    }
    @IBOutlet private var feelLikeTempLabel: UILabel! {
        didSet {
            self.feelLikeTempLabel.font = Theme.Font.smallFont15
            self.feelLikeTempLabel.textColor = Theme.Color.lightGreyColor
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
    @IBOutlet private var maxTemperature: UILabel! {
        didSet {
            self.maxTemperature.font = Theme.Font.mediumFont18
            self.maxTemperature.textColor = Theme.Color.darkColor
        }
    }
    @IBOutlet private var minTemperature: UILabel! {
        didSet {
            self.minTemperature.font = Theme.Font.mediumFont18
            self.minTemperature.textColor = Theme.Color.darkColor
        }
    }
    @IBOutlet private var windDetail: UILabel! {
        didSet {
            self.windDetail.font = Theme.Font.smallFont15
            self.windDetail.textColor = Theme.Color.darkColor
        }
    }
    @IBOutlet private var humidity: UILabel! {
        didSet {
            self.humidity.font = Theme.Font.smallFont15
            self.humidity.textColor = Theme.Color.darkColor
        }
    }
    @IBOutlet private var pressure: UILabel! {
        didSet {
            self.pressure.font = Theme.Font.smallFont15
            self.pressure.textColor = Theme.Color.darkColor
        }
    }
    @IBOutlet private var visibilty: UILabel! {
        didSet {
            self.visibilty.font = Theme.Font.smallFont15
            self.visibilty.textColor = Theme.Color.darkColor
        }
    }
    @IBOutlet private var backgroundBaseView: UIView! {
        didSet {
            self.backgroundBaseView.backgroundColor = Theme.Color.disableGreyColor
            self.backgroundBaseView.layer.cornerRadius = 10
        }
    }
  
    
    // MARK: - Configure
    func configure(with data: CityDetailCellViewModel) {
        self.tempLabel.text = data.temperature
        self.feelLikeTempLabel.text = data.feelsLikeTemp
        self.descriptionLabel.text = data.weatherDescription
        self.maxTemperature.text = data.maxTemperature
        self.minTemperature.text = data.minTemperature
        self.windDetail.text = data.windSpeed
        self.humidity.text = data.humidity
        self.pressure.text = data.pressure
        self.visibilty.text = data.visibility
        self.setIconImage(with: data)
    }
    
    private func setIconImage(with data: CityDetailCellViewModel) {
        UIImage.getImage(icon: data.weatherIcon) { [weak self] (iconImage) in
            DispatchQueue.main.async {
                self?.weatherIconImageView?.image = iconImage
            }
        }
    }
    
    private func setPlaceholderImage() {
        self.weatherIconImageView.image = UIImage.getImage(imageName: .defaultImage)
    }
}
