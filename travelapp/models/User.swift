//
//  User.swift
//  travelapp
//
//  Created by Mitchel Wassler on 11/21/18.
//  Copyright © 2018 Mitchel Wassler. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import SwiftKeychainWrapper


class User  {

    var email:String
    var username:String
    var password:String
    var token:String?
    var profile: [String: String] = [:]
    var error: Bool = false

    init(email: String, username: String, password: String) {
        self.email = email
        self.username = username
        self.password = password
        self.token = nil
    }

    func userLookupSucceded(json: JSON) {
        self.token = json["token"].stringValue
        for (key, object) in json["user"] {
            self.profile[key] = object.stringValue
        }
        KeychainWrapper.standard.set(self.token!, forKey: "Auth_Token")
    }

    func getUser() {
        let parameters: Parameters = [
            "username": self.username,
            "password": self.password
        ]
        Alamofire.request(
            "\(Settings().apiUrl)/auth/login/",
            method: .post,
            parameters: parameters
        ).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                self.userLookupSucceded(json: JSON(value))
            case .failure(let error):
                self.error = true
                print(error)
            }
        }
    }
    
    func save() {
        
    }
    
    static func isLogedIn() -> Bool {
        if (KeychainWrapper.standard.string(forKey: "Auth_Token") != nil) {
            return true
        } else {
            return false
        }
    }
    
    static func authToken() -> String {
        if let token = KeychainWrapper.standard.string(forKey: "Auth_Token")  {
            return token
        } else {
            return ""
        }
    }

}

