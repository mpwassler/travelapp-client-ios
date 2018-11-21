//
//  ViewController.swift
//  travelapp
//
//  Created by Mitchel Wassler on 11/19/18.
//  Copyright © 2018 Mitchel Wassler. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        print( User.isLogedIn() )
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func signIn(_ sender: Any) {
        let user = User(
            email: "",
            username: usernameField.text ?? "",
            password: passwordField.text ?? ""
        )
        user.getUser()
        
    }
    
}


