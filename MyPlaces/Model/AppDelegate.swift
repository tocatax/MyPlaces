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

        let manager = PlaceManager.shared
        
        // Funció per a llegir les dade de l'arxiu json
        let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = docsPath.appendingPathComponent("places.json")

        do {
            let jsonData = try Data(contentsOf: filePath)
            print(jsonData.count)
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
        
        /********************************
         Primera versió de la carrega de dades desde el json.
         Deixo el codi aquí comentat pq el puguis revisar i dir-me si seria una solució vàlida/òptima
        *******************************
        if let path = Bundle.main.path(forResource: "places", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]]
               
                for jsonItem in jsonResult! {
                    if(jsonItem["type"] != nil){
                        let newPlace = PlaceTourist(name: jsonItem["name"] as! String, description: jsonItem["description"] as! String, discount: jsonItem["discount"] as! String, image_in: UIImage(named: jsonItem["image_in"] as! String)?.pngData())
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
        */

        return true
    }
}
