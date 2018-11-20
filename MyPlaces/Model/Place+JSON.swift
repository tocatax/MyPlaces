//
//  Place+JSON.swift
//  MyPlaces
//
//  Created by Toni Casas on 12/11/18.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import MapKit

extension Place: MKAnnotation {
    
    enum PlaceKeys: String, CodingKey {
        case type = "type"
        case name = "name"
        case descript = "descript"
        case latitude = "latitude"
        case longitude = "longitude"
        case discount = "discount"
        case image = "image"
    }
    
    //Conversió de Class a JSON
    func encode(to: Encoder) throws {
        var container = to.container(keyedBy: PlaceKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(name, forKey: .name)
        try container.encode(descript, forKey: .descript)
        try container.encode(location.latitude, forKey: .latitude)
        try container.encode(location.longitude, forKey: .longitude)
        try container.encode(discount, forKey: .discount)
        try container.encode(image, forKey: .image)
        switch type {
            case .generic: try container.encode(PlaceType.generic, forKey: .type)
            case .touristic: try container.encode(PlaceType.touristic, forKey: .type)
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        return location
    }
    
    var title: String? {
        return name
    }
}
