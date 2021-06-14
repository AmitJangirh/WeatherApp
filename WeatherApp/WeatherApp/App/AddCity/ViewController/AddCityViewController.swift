//
//  AddCityViewController.swift
//  WeatherApp
//
//  Created by Amit Jangirh on 14/06/21.
//

import Foundation
import UIKit
import MapKit

protocol AddCityViewControllerDelegate {
    func didAddCity()
}

class AddCityViewController: UIViewController, StoryboardGettable {
    // MARK: - Constant
    struct Constant {
        static let title = "Add City"
        static let currentLocationIdentifier = "MapView_CurrentLocation_Identifier"
    }
    
    // MARK: - IBOutlets
    @IBOutlet private var mapView: MKMapView!
    private var dropAnnotationView: MKAnnotationView?
    var locationManager = CLLocationManager()

    // MARK: - Vars
    var viewModel = AddCityViewModel()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadMapView()
    }
    
    private func setup() {
        setupViewController()
    }
    
    private func setupViewController() {
        self.title = Constant.title
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Theme.Color.tintColor]
        self.navigationController?.navigationBar.barTintColor = Theme.Color.greyColor
        self.navigationController?.navigationBar.backgroundColor = Theme.Color.greyColor
        // Setup right bar button icon
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                                 target: self,
                                                                 action: #selector(searchIconDidPress))
    }
    
    private func loadMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }
    }
    
    @objc func searchIconDidPress() {
        let searchVC = SearchCityViewController.getVC()
        searchVC.delegate = self
        let navVC = UINavigationController(rootViewController: searchVC)
        self.navigationController?.present(navVC, animated: true, completion: nil)
    }
    
    private func loadMap(with lat: Double, lon: Double) {
        // Load region
        let coordinates2D = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: coordinates2D, span: span)
        mapView.regionThatFits(region)
        // Add Anotation
        let pinAnnotaion = MKPointAnnotation();
        pinAnnotaion.coordinate = coordinates2D
        mapView.addAnnotation(pinAnnotaion)
    }
}

extension AddCityViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first?.coordinate else {
            return
        }
        loadMap(with: firstLocation.latitude, lon: firstLocation.longitude)
    }
}

extension AddCityViewController: SearchCityViewControllerDelegate {
    func didSelect(selectedCity: SelectedCityData) {
        loadMap(with: selectedCity.latitude, lon: selectedCity.longitude)
    }
}

extension AddCityViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constant.currentLocationIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: Constant.currentLocationIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        //annotationView?.image = UIImage()
        return annotationView
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        //dropAnnotationView?.removeFromSuperview()
        //mapView.annotations.first.
    }
}
