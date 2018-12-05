//
//  SecondViewController.swift
//  MyPlaces
//
//  Created by Albert Mata Guerra on 28/09/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit
import MapKit

class SecondViewController: UIViewController, MKMapViewDelegate {

    let manager = PlaceManager.shared
    var locationManager = CLLocationManager()
    var placeSelected: Place?
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CASA: 41,603073 - 2,620441
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(manager.places)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailFromMap" {
            if let dc = segue.destination as? DetailController {
                dc.place = placeSelected
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if (view.annotation is Place) {
            placeSelected = manager.places.filter({$0.name == view.annotation?.title}).first
            performSegue(withIdentifier: "ShowDetailFromMap", sender: view.annotation)
        }
    }
}
