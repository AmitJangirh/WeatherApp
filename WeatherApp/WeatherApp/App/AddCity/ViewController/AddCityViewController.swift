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
    }
    
    // MARK: - IBOutlets
    @IBOutlet private var mapView: MKMapView!
    private var dropAnnotationView: MKAnnotationView?
    
    // MARK: - Vars
    var viewModel = HomeViewModel()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupViewController()
        setupMapView()
    }
    
    private func setupViewController() {
        self.title = Constant.title
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Theme.Color.tintColor]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: Theme.Color.tintColor]
        self.navigationController?.navigationBar.barTintColor = Theme.Color.greyColor
        self.navigationController?.navigationBar.backgroundColor = Theme.Color.greyColor
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        // Setup right bar button icon
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                                 target: self,
                                                                 action: #selector(searchIconDidPress))
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    @objc func searchIconDidPress() {
        let searchVC = SearchCityViewController.getVC()
        searchVC.delegate = self
        let navVC = UINavigationController(rootViewController: searchVC)
        self.navigationController?.present(navVC, animated: true, completion: nil)
    }
}

extension AddCityViewController: SearchCityViewControllerDelegate {
    func didSelect(selectedCity: SelectedCityData) {
        
    }
}

extension AddCityViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "sds")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "")
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
