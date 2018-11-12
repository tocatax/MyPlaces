//
//  Place+JSON.swift
//  MyPlaces
//
//  Created by Toni Casas on 12/11/18.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import MapKit

extension PlaceItem {
    
    enum PlaceItemKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case type = "type"
        case latitude = "latitude"
        case longitude = "longitude"
        case image = "image"
    }
    
    init(from: Decoder) throws {
        let container = try from.container(keyedBy: PlaceItemKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let description = try container.decode(String.self, forKey: .description)
        let type = try container.decode(String.self, forKey: .type)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        let location = try CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let image = try container.decode(String.self, forKey: .image)
        
        self.init(name: name, description: description, type: type, location: location, image: image)
    }
    
    func encode(to: Encoder) throws {
        var container = to.container(keyedBy: PlaceItemKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(type, forKey: .type)
        try container.encode(location.latitude, forKey: .latitude)
        try container.encode(location.longitude, forKey: .longitude)
        try container.encode(image, forKey: .image)
    }
}
