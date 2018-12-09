//
//  Place.swift
//  MyPlaces
//
//  Created by Albert Mata Guerra on 28/09/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import MapKit

class Place: NSObject, Codable {

    enum PlaceType: String, Codable {
        case generic
        case touristic
    }
    
    var id = ""
    var type = PlaceType.generic
    var name = ""
    var descript = ""
    var location: CLLocationCoordinate2D!
    var discount = ""
    var image: Data?
    
    override init() {
        self.id = UUID().uuidString
    }
    
    init(location: CLLocationCoordinate2D!) {
        self.id = UUID().uuidString
        self.location = location
    }
    
    init(type: PlaceType, name: String, descript: String, discount: String, image_in: Data?) {
        self.id = UUID().uuidString
        self.type = type
        self.name = name
        self.descript = descript
        self.image = image_in
    }
    
    init(name: String, descript: String, location: CLLocationCoordinate2D!, image_in: Data?) {
        self.id = UUID().uuidString
        self.name = name
        self.descript = descript
        self.location = location
        self.image = image_in
    }
    
    init(type: PlaceType, name: String, descript: String, location: CLLocationCoordinate2D!, discount: String, image_in: Data?) {
        self.id = UUID().uuidString
        self.type = type
        self.name = name
        self.descript = descript
        self.location = location
        self.discount = discount
        self.image = image_in
    }
    
    // Conversio de JSON a CLASS
    required convenience init(from: Decoder) throws {
        let container = try from.container(keyedBy: PlaceKeys.self)
        var type = try container.decode(PlaceType.self, forKey: .type)
        let name = try container.decode(String.self, forKey: .name)
        let descript = try container.decode(String.self, forKey: .descript)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let discount = try container.decode(String.self, forKey: .discount)
        let image = try container.decode(Data?.self, forKey: .image)
        switch type {
            case .generic: type = PlaceType.generic
            case .touristic: type = PlaceType.touristic
        }
        self.init(type: type, name: name, descript: descript, location: location, discount: discount, image_in: image)
    }
}
