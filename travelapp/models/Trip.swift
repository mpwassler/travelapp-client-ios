//
//  Trip.swift
//  travelapp
//
//  Created by Mitchel Wassler on 11/24/18.
//  Copyright © 2018 Mitchel Wassler. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire


class Trip {
    var title: String
    var description: String
    var places : [Place] = []
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
    
    func addPlace(place: Place) {
        self.places.append(place)
    }
    
    func getTripBoundingBox() -> [CLLocationCoordinate2D] {
        guard self.places.count > 0 else {
            return [CLLocationCoordinate2D(latitude: 0, longitude: 0)]
        }
        return self.places.map {place in place.toPoint()}
    }
    
    func save(completed: @escaping (Trip, Error?) -> Void) {
        if self.title != "" {
            let paramaters: Parameters = [
                "title": self.title,
                "description": self.description,
            ]
            Http.POST(url: "\(Settings.apiUrl)/trips/", paramaters: paramaters) {
                trip, error in
                    completed(self, error)
                    print(trip)
                    print(error)
                    
            }
        }
    }
    
    
    func media() {}
    
    static func find(id: Int) {
        
    }
    
    static func all(completed: @escaping ([Trip]?, Error?) -> Void) {
        Http.GET(url: "\(Settings.apiUrl)/trips/") {
            json, error in
            var trips: [Trip] = []
            for tripData in json.arrayValue {
                print(tripData)
                let trip = Trip(
                    title: tripData["title"].stringValue,
                    description: tripData["description"].stringValue
                )
                for placeData in tripData["places"].arrayValue {
                        let place = Place.deserialiseFrom(json: placeData)
                        trip.addPlace(place: place)
                }
                trips += [trip]
            }
            completed(trips, nil)
        }
    }
}
