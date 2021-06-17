//
//  CityDetailViewModel.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 17/06/21.
//

import Foundation
import WeatherAPI

struct CityDetailData {
    var temperature: Double
    var feelsLikeTemp: Double
    var minTemperature: Double
    var maxTemperature: Double
    var pressure: Double
    var humidity: Int
    var visibility: Int
    var weatherDescription: String
    var weatherIcon: String
    var windSpeed: Double
    var windDegree: Int
    var cloudiness: Int
    var cityId: Int
    var cityName: String
    
    init(weatherData: WeatherData) {
        self.temperature = weatherData.main?.temp ?? 0
        self.feelsLikeTemp = weatherData.main?.feelsLike ?? 0
        self.minTemperature = weatherData.main?.minTemperature ?? 0
        self.maxTemperature = weatherData.main?.maxTemperature ?? 0
        self.pressure = weatherData.main?.pressure ?? 0
        self.humidity = weatherData.main?.humidity ?? 0
        self.visibility = weatherData.visibility ?? 0
        self.weatherDescription = weatherData.weather?.first?.description ?? ""
        self.weatherIcon = weatherData.weather?.first?.icon ?? ""
        self.windSpeed = weatherData.wind?.speed ?? 0
        self.windDegree = weatherData.wind?.degree ?? 0
        self.cloudiness = weatherData.clouds?.all ?? 0
        self.cityId = weatherData.id ?? 0
        self.cityName = weatherData.name ?? ""
    }
}

class CityDetailViewModel {
    let data: CityDetailData?
    var sections = [SectionProtocol]()
    // getter
    var title: String {
        return data?.cityName ?? ""
    }
    
    init() {
        self.data = nil
    }
    
    init(data: CityDetailData) {
        self.data = data
        self.generateSections()
    }
    
    private func generateSections() {
        guard let data = self.self.data else {
            return
        }
        // One can append more cells and sections to it
        let detailCell = DetailCell(data: CityDetailCellViewModel(data: data))
        let detailSection = DetailSection(cells: [detailCell])
        self.sections = [detailSection]
    }
    
    func sectionCount() -> Int {
        return self.sections.count
    }
    
    func rowsCount(for section: Int) -> Int {
        return self.sections[section].cells.count
    }
    
    subscript(detailCellDataAt indexPath: IndexPath) -> CityDetailCellViewModel? {
        if let detailCell = self.sections[indexPath.section].cells[indexPath.row] as? DetailCell {
            return detailCell.data
        }
        return nil
    }
}

// MARK: - Protocols
// Base protocol for Section
protocol SectionProtocol {
    var cells: [CellProtocol] { get }
}

// Base protocol for Cell
protocol CellProtocol {}

struct DetailSection: SectionProtocol {
    var cells: [CellProtocol]
}

struct DetailCell: CellProtocol {
    var data: CityDetailCellViewModel
    init(data: CityDetailCellViewModel) {
        self.data = data
    }
}
