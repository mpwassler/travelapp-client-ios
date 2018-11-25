//
//  Trip.swift
//  travelapp
//
//  Created by Mitchel Wassler on 11/24/18.
//  Copyright © 2018 Mitchel Wassler. All rights reserved.
//

import Foundation

class Trip {
    var title: String
    var description: String
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
    
    func places() {}
    
    func media() {}
    
    static func find(id: Int) {
        
    }
    
    static func all(completed: @escaping ([Trip]?, Error?) -> Void) {
        Http.GET(url: "\(Settings.apiUrl)/trips/") {
            json, error in
            var trips: [Trip] = []
            for tripData in json.arrayValue {
                print(tripData)
                trips += [
                    Trip(
                        title: tripData["title"].stringValue,
                        description: tripData["description"].stringValue
                    )
                ]
            }
            completed(trips, nil)
        }
    }
}
