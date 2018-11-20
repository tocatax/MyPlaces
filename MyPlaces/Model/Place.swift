//
//  Place.swift
//  MyPlaces
//
//  Created by Albert Mata Guerra on 28/09/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import MapKit

class Place: NSObject, Codable {

    // We could have created a PlaceType.swift file for this enumeration or just put it in current
    // Place.swift file but outside the class (so, between those "import MapKit" and "class Place {"
    // lines). However if we know we are only going to use it from our Place, it's probably cleaner
    // if the enumeration lives inside the class.
    enum PlaceType: String, Codable {
        case generic
        case touristic
    }
    
    // We don't need to specify types when the compiler can infer them from context. That doesn't
    // mean id or name have no type or can have different types at different moments. No way. Both
    // are and will be String.
    var id = ""
    var type = PlaceType.generic
    var name = ""
    var descript = ""
    var location: CLLocationCoordinate2D!
    var discount = ""
    var image: Data?
    
    // We need to learn a bit more about initialization, but meanwhile we create some initializers.
    // This one has no information about name or description, so it creates an almost empty place.
    override init() {
        self.id = UUID().uuidString
    }
    
    // We need to learn a bit more about initialization, but meanwhile we create some initializers.
    // This one creates a generic place with basic name and description information.
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
    
    // We need to learn a bit more about initialization, but meanwhile we create some initializers.
    // This one creates a generic or touristic place (based on parameter) with basic name and
    // description information. But wait a minute... shouldn't we create a PlaceTourist instance
    // if we wanted a touristic place? :)
    init(type: PlaceType, name: String, descript: String, location: CLLocationCoordinate2D!, discount: String, image_in: Data?) {
        self.id = UUID().uuidString
        self.type = type
        self.name = name
        self.descript = descript
        self.location = location
        self.discount = discount
        self.image = image_in
    }
    
    //Conversio de JSON a CLASS
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
