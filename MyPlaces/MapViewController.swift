//
//  MapViewController.swift
//  MyPlaces
//
//  Created by Vladimir Strepitov on 10.05.2022.
//

import UIKit
import MapKit


protocol MapViewControllerDelegate {
    func getAddress(_ address: String?)
}

class MapViewController: UIViewController {

    let mapManager = MapManager()
    var mapViewControllerDelegate: MapViewControllerDelegate?
    var place: Place!
    var annotationIdentifier = "annotationIdentifier"
    var incomeSegueIdentifier = ""

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapPinImage: UIImageView!
    @IBOutlet weak var currentAddressLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentAddressLabel.text = ""
        mapView.delegate = self
        setupMapView()
    }

    @IBAction func centerViewInUserLocation() {
        mapManager.showUserLocation(mapView: mapView)
        
    }
    
    @IBAction func exitVC() {
        dismiss(animated: true)
    }
    
    @IBAction func doneButtonPressed() {
        mapViewControllerDelegate?.getAddress(currentAddressLabel.text)
        dismiss(animated: true)
    }
    
    private func setupMapView() {
        
        mapManager.checkLocationServices(mapView: mapView, segueIdentifier: incomeSegueIdentifier) {
            mapManager.locationManager.delegate = self
        }
        if incomeSegueIdentifier == "showPlace" {
            currentAddressLabel.isHidden = true
            doneButton.isHidden = true
            mapManager.setupPlacemark(place: place, mapView: mapView)
            mapPinImage.isHidden = true
        }
    }
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        
        if let imageData = place.imageData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            annotationView?.rightCalloutAccessoryView = imageView
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapManager.getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(center) { placemarks, error in
            if let error = error {
                print(error)
                return
            } else {
                guard let placemarks = placemarks else { return }
                let placemark = placemarks.first
                let streetName = placemark?.thoroughfare
                let buildNumber = placemark?.subThoroughfare
                
                DispatchQueue.main.async {
                    if buildNumber != nil && buildNumber != nil {
                        self.currentAddressLabel.text = "\(streetName!), \(buildNumber!)"
                    } else if streetName != nil {
                        self.currentAddressLabel.text = "\(streetName!)"
                    } else {
                        self.currentAddressLabel.text = ""
                    }
                    
                }
                
            }
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        mapManager.checkLocationAuthorization(mapView: mapView, segueIdentifier: incomeSegueIdentifier)
    }
}
