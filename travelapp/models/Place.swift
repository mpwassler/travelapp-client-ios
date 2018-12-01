//
//  Place.swift
//  travelapp
//
//  Created by Mitchel Wassler on 11/25/18.
//  Copyright © 2018 Mitchel Wassler. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

class Place {
    var id: Int
    var caption: String?
    var date: String
    var latitude: Double
    var longitude: Double
    var geoJSONString: String = ""
    
    init(id: Int, caption: String, date: String, latitude: Double, longitude: Double ) {
        self.id = id
        self.caption = caption
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func setGeoJson() {
        
    }
    
    func toPoint() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    static func deserialiseFrom(json: JSON) -> Place {
        return Place(
            id: json["id"].intValue,
            caption: json["label"].stringValue,
            date: json["created_at"].stringValue,
            latitude: json["location"]["coordinates"].arrayValue[1].doubleValue,
            longitude: json["location"]["coordinates"].arrayValue[0].doubleValue
        )
    }
}
