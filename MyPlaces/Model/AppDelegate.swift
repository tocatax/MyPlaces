//
//  AppDelegate.swift
//  MyPlaces
//
//  Created by Albert Mata Guerra on 28/09/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit
import MapKit
import Firebase

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let manager = PlaceManager.shared
        
        FirebaseApp.configure()
        
        // Funció per a llegir les dade de l'arxiu json
        let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = docsPath.appendingPathComponent("places.json")

        do {
            let jsonData = try Data(contentsOf: filePath)
            if(jsonData.count > 0){
                let places = manager.placesFrom(jsonData: jsonData)
                for place in places {
                    manager.append(place)
                }
            }else{
                print("Error en Datos")
                let places = manager.TestPlaces
                for place in places {
                    manager.append(place)
                }
            }
        } catch {
            print("Error en archivo")
            let places = manager.TestPlaces
            for place in places {
                manager.append(place)
            }
        }

        return true
    }
}
