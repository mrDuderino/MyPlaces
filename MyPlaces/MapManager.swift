//
//  MapManager.swift
//  MyPlaces
//
//  Created by Vladimir Strepitov on 23.05.2022.
//

import UIKit
import MapKit


class MapManager {
    
    let locationManager = CLLocationManager()
    private let regionInMeters: Double = 5000
    
    func setupPlacemark(place: Place, mapView: MKMapView) {
        
        guard let location = place.location else { return }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { placemarks, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            annotation.subtitle = place.type
            
            guard let placemarkLocation = placemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            
            mapView.showAnnotations([annotation], animated: true)
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    func checkLocationServices(mapView: MKMapView, segueIdentifier: String, closure: () -> ()){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAuthorization(mapView: mapView, segueIdentifier: segueIdentifier)
            closure()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(withTitle: "Location Service is disabled",
                          message: "To enable it go: Settings -> Privacy -> Location Services and turn On")
            }
        }
    }
    
    func checkLocationAuthorization(mapView: MKMapView, segueIdentifier: String) {
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            showAlert(withTitle: "Location Service is not available",
                      message: "To give permission - go to: Settings -> MyPlaces -> Location")
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse: // in the moment of use
            mapView.showsUserLocation = true
            if segueIdentifier == "getAddress" {
                showUserLocation(mapView: mapView)
            }
            break
        @unknown default:
            print("new case is available")
        }
    }
    
    // Focus on user location
    func showUserLocation(mapView: MKMapView) {
        
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // Define the center of the map area
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    private func showAlert(withTitle title: String, message: String) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        ac.addAction(okAction)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(ac, animated: true)
    }
    
    
}
