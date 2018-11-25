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
    
    static func headers() -> HTTPHeaders {
        guard let token = Auth.token(), token != "" else {
            return ["Accept": "application/json"]
        }
        return [
            "Authorization": "JWT \(token)",
            "Accept": "application/json"
        ]
    }
    
    static func handleUnauthorized(code : Int?) {
        if let c = code {
            if c == 401 {
                Auth.logout()
            }
        }
    }
    
    static func GET(url: String, cb:  @escaping (JSON, Error?) -> Void ) {
        Alamofire.request(
            url,
            method: .get,
            headers: Http.headers()
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
        print(Http.headers())
        Alamofire.request(
            url,
            method: .post,
            parameters: paramaters,
            headers: Http.headers()
            ).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    cb(JSON(value), nil)
                case .failure(let error):
                    print(error)
                    Http.handleUnauthorized(code: response.response?.statusCode)
                    cb(JSON(), error)
                }
        }
    }
    
    static func PUT() {
        
    }
    
    static func DELETE() {
        
    }
}
