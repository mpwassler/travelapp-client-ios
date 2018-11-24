//
//  SignUpViewController.swift
//  travelapp
//
//  Created by Mitchel Wassler on 11/23/18.
//  Copyright © 2018 Mitchel Wassler. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccount(_ sender: Any) {
        if let un = userNameField.text,
           let em = emailField.text,
           let pw = passwordField.text,
           let pwc = confirmPasswordField.text {
           Auth.create(username: un, email: em, password: pw, passwordConfirm: pwc) {
            user, error in
                if let u = user {
                    let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "mainnav") as! UITabBarController
                    let profileController =  viewController.viewControllers![0] as! ProfileViewController
                    profileController.setUser(user: u)
                    self.present(viewController, animated: true, completion: nil)
                }
           }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
