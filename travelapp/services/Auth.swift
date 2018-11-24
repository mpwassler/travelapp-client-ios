//
//  Auth.swift
//  travelapp
//
//  Created by Mitchel Wassler on 11/24/18.
//  Copyright © 2018 Mitchel Wassler. All rights reserved.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

class Auth {
    static func create(username: String, email: String, password: String, passwordConfirm: String, completed: @escaping (User?, Error?) -> Void) {
        let parameters: Parameters = [
            "username": username,
            "email": email,
            "password1": password,
            "password2": passwordConfirm
        ]
        Http.POST(
            url: "\(Settings.apiUrl)/auth/registration/",
            paramaters: parameters
        ) { json, hasError in
            let user = User(
                email: json["user"]["email"].stringValue,
                username: json["user"]["username"].stringValue,
                password: nil,
                id:json["user"]["pk"].intValue,
                token: json["token"].stringValue
            )
            completed(user, nil)
        }
    }
    
    static func login (username: String, password: String, completed: @escaping (User?, Error?) -> Void) {
        let parameters: Parameters = [
            "username": username,
            "password": password
        ]
        Http.POST(url: "\(Settings.apiUrl)/auth/login/", paramaters: parameters) { json, err in
            let user = User(
                email: json["user"]["email"].stringValue,
                username: json["user"]["username"].stringValue,
                password: nil,
                id:json["user"]["pk"].intValue,
                token: json["token"].stringValue
            )
            completed(user, nil)
        }
    }
    
    
    static func isLogedIn(completed: @escaping (Any?, Error?) -> Void) {
        Http.GET(url: "\(Settings.apiUrl)/auth/user/") { json, err in
            completed(json, err)
        }
    }
    
    static func token() -> String? {
        if let token = KeychainWrapper.standard.string(forKey: "Auth_Token")  {
            return token
        }
        return nil
    }
}
