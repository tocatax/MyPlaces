//
//  LocationController.swift
//  MyPlaces
//
//  Created by Toni Casas on 22/11/18.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit
import MapKit

class LocationController: UIViewController, UINavigationControllerDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    var annotation = MKPointAnnotation()
    var coordinates = CLLocationCoordinate2D()
    var locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        locationManager.delegate = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)

        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        
        guard let coordinate = locationManager.location?.coordinate else { return }
        coordinates = coordinate
        locationManager.stopUpdatingLocation()
    }

    @IBAction func cancelar_bt(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func guardar_bt(_ sender: Any) {
        performSegue(withIdentifier: "unwindToAddModify", sender: coordinates)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToAddModify" {
            if let dc = segue.destination as? addModifyContoller {
                dc.coordinates = coordinates
            }
        }
    }
    
    @objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {
        let location = gestureReconizer.location(in: mapView)
        coordinates = mapView.convert(location,toCoordinateFrom: mapView)
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
    }
}
