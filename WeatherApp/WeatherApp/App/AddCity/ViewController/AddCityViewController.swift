//
//  AddCityViewController.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 14/06/21.
//

import Foundation
import UIKit
import MapKit

protocol AddCityData {
    var cityName: String { get }
    var cityId: UInt? { get set }
    var latitude: Double { get }
    var longitude: Double { get }
    var state: String { get }
    var country: String { get }
}

struct AddCity: AddCityData {
    var cityName: String
    var cityId: UInt?
    var latitude: Double
    var longitude: Double
    var state: String
    var country: String
}

protocol AddCityViewControllerDelegate: class {
    func addCity(cityData: AddCityData)
}

class AddCityViewController: UIViewController, StoryboardGettable {
    // MARK: - Constant
    struct Constant {
        static let title = "Add City"
        static let confirmButtonTitle = "Confirm"
        static let confirmButtonCornerRadius: CGFloat = 10
        static let currentLocationIdentifier = "MapView_CurrentLocation_Identifier"
    }
    
    // MARK: - IBOutlets
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var confirmButton: UIButton!

    // MARK: - Vars
    var viewModel = AddCityViewModel()
    weak var delegate: AddCityViewControllerDelegate?
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchUserLocation()
    }
    
    private func setup() {
        setupViewController()
        setupMapView()
        setupConfirmButton()
    }
    
    private func setupViewController() {
        self.title = Constant.title
        self.setupCommonNavigation()
        // Setup right bar button icon
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                                 target: self,
                                                                 action: #selector(searchIconDidPress))
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    private func setupConfirmButton() {
        confirmButton.setTitle(Constant.confirmButtonTitle, for: .normal)
        confirmButton.layer.cornerRadius = Constant.confirmButtonCornerRadius
        confirmButton.backgroundColor = Theme.Color.greyColor
        confirmButton.setTitleColor(Theme.Color.tintColor, for: .normal)
        confirmButton.titleLabel?.font = Theme.Font.mediumFont22
    }
    
    private func fetchUserLocation() {
        // Fetch location
        viewModel.fetchLocation { [weak self] (cityData) in
            DispatchQueue.main.async {
                self?.viewModel.selectedCity = cityData
                self?.loadMap(with: cityData?.latitude ?? 0,
                              lon: cityData?.longitude ?? 0)
            }
        }
    }
    
    @objc func searchIconDidPress() {
        let searchVC = SearchCityViewController.getVC()
        searchVC.delegate = self
        let navVC = UINavigationController(rootViewController: searchVC)
        self.navigationController?.present(navVC, animated: true, completion: nil)
    }
    
    private func loadMap(with lat: Double, lon: Double) {
        // Set region
        let coordinates2D = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: coordinates2D, span: span)
        mapView.setRegion(region, animated: true)
        // Add Anotation
        let pinAnnotaion = MKPointAnnotation()
        pinAnnotaion.title = "Current Location"
        pinAnnotaion.coordinate = coordinates2D
        mapView.addAnnotation(pinAnnotaion)
    }
    
    @IBAction private func didConfirmLocation() {
        guard let selectedCity = viewModel.selectedCity else {
            return
        }
        self.delegate?.addCity(cityData: selectedCity)
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddCityViewController: SearchCityViewControllerDelegate {
    func didSelect(selectedCity: SearchedCityData) {
        viewModel.selectedCity = AddCity(cityName: selectedCity.cityName,
                                         cityId: selectedCity.cityId,
                                         latitude: selectedCity.latitude,
                                         longitude: selectedCity.longitude,
                                         state: selectedCity.state,
                                         country: selectedCity.country)
        loadMap(with: selectedCity.latitude, lon: selectedCity.longitude)
    }
}

extension AddCityViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constant.currentLocationIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: Constant.currentLocationIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
}
