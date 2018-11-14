//
//  AppDelegate.swift
//  MyPlaces
//
//  Created by Albert Mata Guerra on 28/09/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit
import MapKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // We add some test places so the app can show some information when it loads. When we start
        // creating our own real content we will need to remove this part, of course.
        let manager = PlaceManager.shared
        
        if let path = Bundle.main.path(forResource: "places", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]]
               
                for jsonItem in jsonResult! {
                    if(jsonItem["type"] != nil){
                        let newPlace = PlaceTourist(name: jsonItem["name"] as! String, description: jsonItem["description"] as! String, discount_tourist: jsonItem["discount_tourist"] as! String, image_in: UIImage(named: jsonItem["image_in"] as! String)?.pngData())
                        manager.append(newPlace)
                    } else {
                        let newPlace = Place(name: jsonItem["name"] as! String, description: jsonItem["description"] as! String, image_in: UIImage(named: jsonItem["image_in"] as! String)?.pngData())
                        manager.append(newPlace)
                    }

                }
            } catch {
                print("NO FILE")
            }
        }
        return true
    }
}