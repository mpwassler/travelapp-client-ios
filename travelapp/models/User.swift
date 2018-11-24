//
//  User.swift
//  travelapp
//
//  Created by Mitchel Wassler on 11/21/18.
//  Copyright © 2018 Mitchel Wassler. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper


class User  {

    public var email:String
    public var username:String
    var password:String
    var token:String?
    public var id:Int?
    var profile: [String: String] = [:]
    var error: Bool = false

    init(email: String, username: String, password: String?, id: Int?, token: String?) {
        self.email = email
        self.username = username
        self.password = password ?? ""
        self.token = token ?? nil
        self.id = id ?? nil
        
        if let t = token {
          KeychainWrapper.standard.set(t, forKey: "Auth_Token")
        }
    }

}

