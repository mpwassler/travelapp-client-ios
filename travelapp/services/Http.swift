//
//  Http.swift
//  travelapp
//
//  Created by Mitchel Wassler on 11/23/18.
//  Copyright © 2018 Mitchel Wassler. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Http {
    static func GET(url: String, cb:  @escaping (JSON, Error?) -> Void ) {
        Alamofire.request(
            url,
            method: .get
            ).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    cb(JSON(value), nil)
                case .failure(let error):
                    cb(JSON(), error)
                }
        }
    }
    
    static func POST(url: String, paramaters: Parameters, cb: @escaping (JSON, Error?) -> Void) {
        Alamofire.request(
            url,
            method: .post,
            parameters: paramaters
            ).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    cb(JSON(value), nil)
                case .failure(let error):
                    print(error)
                    cb(JSON(), error)
                }
        }
    }
    
    static func PUT() {
        
    }
    
    static func DELETE() {
        
    }
}
