//
//  AddCityViewController.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 14/06/21.
//

import Foundation
import UIKit
import MapKit

protocol AddCityViewControllerDelegate: class {
    func addCity(cityData: SelectedCityData)
}

struct AddCityData: SelectedCityData {
    var cityName: String
    var cityId: UInt
    var latitude: Double
    var longitude: Double
}

class AddCityViewController: UIViewController, StoryboardGettable {
    // MARK: - Constant
    struct Constant {
        static let title = "Add City"
        static let currentLocationIdentifier = "MapView_CurrentLocation_Identifier"
    }
    
    // MARK: - IBOutlets
    @IBOutlet private var mapView: MKMapView!

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
    }
    
    private func setupViewController() {
        self.title = Constant.title
        self.navigationController?.navigationBar.barTintColor = Theme.Color.greyColor
        self.navigationController?.navigationBar.backgroundColor = Theme.Color.greyColor
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Theme.Color.tintColor]
        self.navigationController?.navigationBar.tintColor = Theme.Color.tintColor
        // Setup right bar button icon
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                                 target: self,
                                                                 action: #selector(searchIconDidPress))
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
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
    
    private func didConfirmLocation() {
        guard let selectedCity = viewModel.selectedCity else {
            return
        }
        self.delegate?.addCity(cityData: selectedCity)
    }
}

extension AddCityViewController: SearchCityViewControllerDelegate {
    func didSelect(selectedCity: SelectedCityData) {
        viewModel.selectedCity = selectedCity
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
