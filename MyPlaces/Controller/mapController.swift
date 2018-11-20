//
//  SecondViewController.swift
//  MyPlaces
//
//  Created by Albert Mata Guerra on 28/09/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit
import MapKit

class SecondViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let manager = PlaceManager.shared
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //CASA: 41,603073 - 2,620441
        
        let region = MKCoordinateRegion(center: manager.places[4].coordinate, latitudinalMeters: 15_000, longitudinalMeters: 15_000)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotations(manager.places)
        mapView.showsUserLocation = true
    }
}
