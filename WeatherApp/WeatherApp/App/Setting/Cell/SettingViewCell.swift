//
//  SegmentViewCell.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 17/06/21.
//

import Foundation
import UIKit

class SegmentViewCell: UITableViewCell, TableCellAdaptable {
    // MARK: - OBOutlets
    @IBOutlet private var temperatureUnit: UILabel! {
        didSet {
            self.temperatureUnit.font = Theme.Font.mediumFont18
            self.temperatureUnit.textColor = Theme.Color.greyColor
            self.temperatureUnit.numberOfLines = 0
        }
    }
    @IBOutlet private var segmentControl: UISegmentedControl! {
        didSet {
            self.segmentControl.tintColor = Theme.Color.tintColor
            self.segmentControl.backgroundColor = Theme.Color.greyColor
        }
    }
    
    // MARK: - Configure cell
    func configure(with rowData: SettingRowRepresentable) {
        guard let settingRow = rowData as? TemperatureRow else {
            return
        }
        self.temperatureUnit.text = settingRow.title
        for value in settingRow.values {
            self.segmentControl.setTitle(value.rawValue, forSegmentAt: value.index)
        }
        self.segmentControl.selectedSegmentIndex = SettingStorage.shared.temperatureUnit.index
    }
    
    @IBAction func changeValue(sender: UISegmentedControl) {
        if let selectedSetting = TemperatureRow.TemperatureUnit(index: sender.selectedSegmentIndex) {
            SettingStorage.shared.temperatureUnit = selectedSetting
        }
    }
}

struct Person: Codable {
    enum Keys: String, CodingKey {
        case name
        case lastName
    }
    
    var name: String
    var lastName: String
}