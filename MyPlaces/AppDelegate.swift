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
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [[String: Any]] 

                for place in jsonResult! {
                    //manager.append(place)
                }
            } catch {
                print("NO FILE")
            }
        }
        return true
    }
}

struct PlaceItem: Codable {
    var name: String
    var description: String
    var type: String
    var location: CLLocationCoordinate2D!
    var image: String
    
    init(name: String, description: String, type: String, location: CLLocationCoordinate2D, image: String){
        self.name = name
        self.description = description
        self.type = type
        self.location = location
        self.image = image
    }
}
