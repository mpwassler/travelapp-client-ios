//
//  AddTripViewController.swift
//  travelapp
//
//  Created by Mitchel Wassler on 11/26/18.
//  Copyright © 2018 Mitchel Wassler. All rights reserved.
//

import UIKit

class AddTripViewController: UIViewController {
    
    var trip : Trip?

    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var descriptionField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveTrip(_ sender: Any) {
        
        let trip = Trip(
            title: titleField.text!,
            description: descriptionField!.text ?? ""
        )
        
        trip.save { trip, error in
             self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
