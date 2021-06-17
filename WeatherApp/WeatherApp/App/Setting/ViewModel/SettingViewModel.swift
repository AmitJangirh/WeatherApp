//
//  SettingViewModel.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 17/06/21.
//

import Foundation
import WeatherStorage

class SettingViewModel {
    var sections: [SettingSectionRepresentable] = []

    init() {
        buildSections()
    }
    
    private func buildSections() {
        let unitSection = UnitSection(cells: [TemperatureRow()])
        self.sections = [unitSection]
    }
    
    func sectionCount() -> Int {
        return sections.count
    }
    
    func rowsCount(for section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func sectionTitle(at section: Int) -> String {
        self.sections[section].title
    }
    
    subscript(cellAt indexPath: IndexPath) -> SettingRowRepresentable {
        sections[indexPath.section].cells[indexPath.row]
    }
}

// MARK: - Section - Row

protocol SettingSectionRepresentable {
    var title: String { get set }
    var cells: [SettingRowRepresentable] { get set }
}

enum RowType {
    case segmentControl
}

protocol SettingRowRepresentable {
    var type: RowType { get set }
}

// MARK: - Units section

struct UnitSection: SettingSectionRepresentable {
    var title: String = "Units"
    var cells: [SettingRowRepresentable]
}

protocol SegmentRowRepresentable: SettingRowRepresentable {
    associatedtype ValueType
    var title: String { get set }
    var values: [ValueType] { get set }
    var selectedValue: ValueType { get set }
}

struct TemperatureRow: SegmentRowRepresentable {
    typealias ValueType = TemperatureUnit
        
    enum TemperatureUnit: String, CaseIterable {
        case celsius = "\u{00B0} C"
        case fahrenheit = "\u{00B0} F"
        
        var index: Int {
            switch self {
            case .celsius: return 0
            case .fahrenheit: return 1
            }
        }
        
        init?(index: Int) {
            switch index {
            case 0: self = .celsius
            case 1: self = .fahrenheit
            default:
                return nil
            }
        }
        
        static let defaultValue = TemperatureUnit.celsius
    }

    var type: RowType = .segmentControl
    var title: String = "Temperature"
    var values: [TemperatureUnit] = TemperatureUnit.allCases
    var selectedValue: TemperatureUnit = .celsius
}
