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
import SwiftEventBus

class Auth {
    public var user : User?
    
    static let instance = Auth()
    
    private init() {}
    
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
            Auth.instance.user = user
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
            Auth.instance.user = user
            completed(user, nil)
        }
    }
    
    static func logout() {
        Auth.instance.user = nil
        KeychainWrapper.standard.removeObject(forKey: "Auth_Token")
        SwiftEventBus.post("AUTH_LOGOUT")
    }
    
    
    static func isLogedIn(completed: @escaping (Any?, Error?) -> Void) {
        Http.GET(url: "\(Settings.apiUrl)/auth/user/") { json, err in
            completed(json, err)
        }
    }
    
    static func token() -> String? {
        if let token = KeychainWrapper.standard.string(forKey: "Auth_Token")  {
            print(token)
            return token
        }
        return nil
    }
}
