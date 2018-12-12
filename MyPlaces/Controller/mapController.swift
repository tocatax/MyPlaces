//
//  SecondViewController.swift
//  MyPlaces
//
//  Created by Albert Mata Guerra on 28/09/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth

class SecondViewController: UIViewController, MKMapViewDelegate {

    let manager = PlaceManager.shared
    var locationManager = CLLocationManager()
    var placeSelected: Place?
    @IBOutlet weak var mapView: MKMapView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(manager.places)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(manager.places)
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
    
    @IBAction func logoutBt(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            print("Logout")
            performSegue(withIdentifier: "unwindToLogin", sender: nil)
        } catch {}
    }
    
    @IBAction func userLocationBt(_ sender: Any) {
        let userLocation = mapView.userLocation.coordinate
        let Region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1_100, longitudinalMeters: 1_100)
        mapView.setRegion(Region, animated: true)
    }
}
