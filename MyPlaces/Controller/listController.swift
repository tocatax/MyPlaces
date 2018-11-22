//
//  FirstViewController.swift
//  MyPlaces
//
//  Created by Albert Mata Guerra on 28/09/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit

// Do you see those MARK lines there in the code? They do nothing (of course, they are comments
// after all). But that special syntax let you define some nice sections in the header. Have a look
// at the bar at the top of this code file. You should see something like...
// MyPlaces > MyPlaces > FirstViewController.swift > No Selection
// Click on the last element and you will get a drop down list from which you can navigate to any
// method in current file. Those MARK lines let you specify some sections to group related methods.

// FirstViewController is subclass of UITableViewController.
// UITableViewController is subclass of UIViewController.
// UITableViewController adopts two protocols: UITableViewDelegate and UITableViewDataSource.
// So, by being a subclass of UITableViewController, our FirstViewController:
//     1) is also a subclass of UIViewController,
//     2) automatically adopts both UITableViewDelegate and UITableViewDataSource protocols.
class FirstViewController: UITableViewController {
    @IBOutlet var placeTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Never forget to set delegate and dataSource for our UITableView!
        let view = self.view as! UITableView
        view.delegate = self
        view.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        placeTable.reloadData()
    }

    // MARK: - Methods declared in UITableViewDataSource

    // We never call this method. iOS will call it when it needs some information. And this method
    // is our chance to inform iOS about how many sections the table must show. This is because
    // tables can show information in different sections. For instance, at some point we may want
    // to show a first section with all generic places and a second section with all touristic
    // places. But for now we're showing all places together. So, one section.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // We never call this method. iOS will call it when it needs some information. And this method
    // is our chance to inform iOS about how many rows the table must show for each section. As we
    // only have one section, it will have as many rows as places in our PlaceManager.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlaceManager.shared.count()
    }

    // We never call this method. iOS will call it when it needs some information. And this method
    // is our chance to inform iOS about what cell it has to show for a given index. We build that
    // cell and then return it.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Given an index, we ask our PlaceManager for the place at that index.
        let place = PlaceManager.shared.itemAt(position: indexPath.item)!
        // We ask our table for a reusable cell. Then we set its basic details and return it.
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCellItem", for: indexPath) as! PlaceCellItem
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
    
    // MARK: - Methods declared in UITableViewDelegate
    
    // We never call this method. iOS will call it when it wants to tell us that a row has been
    // selected. We can just ignore that (and add no code in this method) if we just don't care when
    // the user selects a row. But if we want to do something (like navigate to a different screen),
    // we need to add the code for that action in this method.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // First we find out what place the user has selected.
        let selPlace = PlaceManager.shared.itemAt(position: indexPath.row)
        // Then we ask the app to take the "ShowPlaceDetail" road (segue) to a different screen.
        performSegue(withIdentifier: "ShowDetail", sender: selPlace)
    }
    
    // We never call this method. iOS will call it when it needs some information. And this method
    // is our chance to inform iOS about how tall our cells are. iOS needs this information to
    // perform some calculations about scrolling sizes, etc. Do not worry too much about the value
    // you return: anything not too far from the real height value of your cells will be OK.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: - Navigation
    
    // See where we said... we ask the app to take the "ShowPlaceDetail" road (segue) to a different
    // screen? OK. When we ask the app to take any road (performSegue), iOS will call this method
    // in case any preparation is required. In this case, we're only checking which road to take
    // and, if it is the "ShowPlaceDetail" one, we send the place object to the destination screen.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            if let dc = segue.destination as? DetailController {
                dc.place = sender as? Place
            }
        }
    }
    
    @IBAction func unwindToListController(_ sender: UIStoryboardSegue){
        
    }
}
