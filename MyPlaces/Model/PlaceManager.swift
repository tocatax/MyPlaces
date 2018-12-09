//
//  PlaceManager.swift
//  MyPlaces
//
//  Created by Albert Mata Guerra on 28/09/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PlaceManager {
    
    //Singleton
    static let shared = PlaceManager()
    private init() {}
    
    var places = [Place]()
    
    // Afegir una place
    func append(_ place: Place) {
        places.append(place)
    }

    // Retorna el número de places
    func count() -> Int {
        return places.count
    }
    
    // Retorna la place d'una posició especificada
    func itemAt(position: Int) -> Place? {
        guard position < places.count else { return nil }
        return places[position]
    }
    
    // Retorna una place amb un ID especificat
    func itemWithId(_ id: String) -> Place? {
        return places.filter {$0.id == id}.first
    }
    
    // Eliminar una place
    func remove(_ place: Place) {
        places = places.filter {$0.id != place.id}
    }
    
    // Codificar array de places a JSON
    func jsonFrom(places: [Place]) -> Data? {
        var jsonData: Data? = nil
        let jsonEncoder = JSONEncoder()
        do {
            jsonData = try jsonEncoder.encode(places)
        } catch {
            return nil
        }
        return jsonData
    }
    
    // Descodificar el JSON a un array de places
    func placesFrom(jsonData: Data) -> [Place] {
        let jsonDecoder = JSONDecoder()
        let places: [Place]
        do {
            places = try jsonDecoder.decode([Place].self, from: jsonData)
        } catch {
            return []
        }
        return places
    }
    
    // Dades generiques per a l'app
    let TestPlaces = [
        Place(
            type: .generic,
            name: "UOC 22@",
            descript: "Seu de la Universitat Oberta de Catalunya. Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.  Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.  Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.",
            location: CLLocationCoordinate2D(latitude: 41.406574, longitude: 2.194534),
            discount: "",
            image_in: UIImage(named: "uoc")?.pngData()),
        Place(
            type: .generic,
            name: "Rostisseria Lolita",
            descript: "Els millors pollastres de Sant Cugat",
            location: CLLocationCoordinate2D(latitude: 41.482236, longitude: 2.091173),
            discount: "",
            image_in: UIImage(named: "lolita")?.pngData()),
        Place(
            type: .generic,
            name: "CIFO L'Hospitalet",
            descript: "Seu del Centre d'Innovació i Formació per a l'Ocupació",
            location: CLLocationCoordinate2D(latitude: 41.358643, longitude: 2.114072),
            discount: "",
            image_in: UIImage(named: "cifo")?.pngData()),
        Place(
            type: .touristic,
            name: "CosmoCaixa",
            descript: "Museu de la Ciència de Barcelon",
            location: CLLocationCoordinate2D(latitude: 41.413092, longitude: 2.131416),
            discount: "50",
            image_in: UIImage(named: "cosmocaixa")?.pngData()),
        Place(
            type: .touristic,
            name: "Park Güell",
            descript: "Obra d'Antoni Gaudí a Barcelona",
            location: CLLocationCoordinate2D(latitude: 41.413236, longitude: 2.152848),
            discount: "20",
            image_in: UIImage(named: "park-guell")?.pngData())
    ]
}
