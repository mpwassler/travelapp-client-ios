//
//  ViewController.swift
//  travelapp
//
//  Created by Mitchel Wassler on 11/19/18.
//  Copyright © 2018 Mitchel Wassler. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func signIn(_ sender: Any) {
        if let un = usernameField.text, let pw = passwordField.text {
            Auth.login(username: un, password: pw) { user, err in
                if let u = user {
                    let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "mainnav") as! UITabBarController
                    let profileController =  viewController.viewControllers![0] as! ProfileViewController
                    profileController.setUser(user: u)
                    self.present(viewController, animated: true, completion: nil)
                }
            }
        }
    }
    
}


