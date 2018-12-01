//
//  ProfileViewController.swift
//  travelapp
//
//  Created by Mitchel Wassler on 11/23/18.
//  Copyright © 2018 Mitchel Wassler. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileLabel: UILabel!
    
    var user: User? = nil
    var trips: [Trip] = []
    
    func setUser(user: User) {
        self.user = user
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My Trips"
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let u = Auth.instance.user {
            self.profileLabel.text = "Welcome \(u.username)"
            Trip.all { trips, err in
                if let t = trips {
                    self.trips = t
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.trips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        let trip = self.trips[indexPath.row]
        cell.displayContent(trip: trip)
        return cell
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.destination)
        print(sender)
        switch (segue.destination, sender) {
        case (let controller as TripDetailViewController, let cell as ProfileCollectionViewCell):
            var indexPath = self.collectionView.indexPath(for: cell)
            controller.trip = trips[indexPath!.row]
            
        default:
            print("unknown segue")
            break
        }
    }

}
