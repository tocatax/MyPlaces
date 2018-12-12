//
//  FirstViewController.swift
//  MyPlaces
//
//  Created by Albert Mata Guerra on 28/09/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth

class FirstViewController: UITableViewController {

    let locationManager = CLLocationManager()
    @IBOutlet var placeTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        let view = self.view as! UITableView
        view.delegate = self
        view.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        placeTable.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlaceManager.shared.count()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place = PlaceManager.shared.itemAt(position: indexPath.item)!
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCellItem", for: indexPath) as! PlaceCellItem
        
        cell.backgroundColor = .clear
        cell.name_txt.text = place.name
        cell.description_txt.text = place.descript
        cell.discount_txt.text = ""
        switch place.type {
            case .generic:
                cell.colorBarType.backgroundColor = UIColor(red:0.97, green:0.67, blue:0.09, alpha:1.0)
            case .touristic:
                if(place.discount.count > 0){
                    cell.discount_txt.text = "-\(place.discount)%"
                }
                cell.colorBarType.backgroundColor = UIColor(red:0.32, green:0.64, blue:0.23, alpha:1.0)
        }

        if(place.image != nil){
            cell.place_img.image = UIImage(data: place.image!)
        }else{
            cell.place_img.image = nil
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selPlace = PlaceManager.shared.itemAt(position: indexPath.row)
        performSegue(withIdentifier: "ShowDetail", sender: selPlace)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            if let dc = segue.destination as? DetailController {
                dc.place = sender as? Place
            }
        }
    }
    
    @IBAction func logoutBt(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            print("Logout")
            performSegue(withIdentifier: "unwindToLogin", sender: nil)
        } catch {}
    }
    
    @IBAction func unwindToListController(_ sender: UIStoryboardSegue){}
}
