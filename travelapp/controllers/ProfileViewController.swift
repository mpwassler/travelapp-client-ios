//
//  ProfileViewController.swift
//  travelapp
//
//  Created by Mitchel Wassler on 11/23/18.
//  Copyright © 2018 Mitchel Wassler. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var user: User? = nil
    
    func setUser(user: User) {
        self.user = user
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(user?.username)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let u = user {
            
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