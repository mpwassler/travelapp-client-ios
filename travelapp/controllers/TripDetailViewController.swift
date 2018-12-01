//
//  TripDetailViewController.swift
//  travelapp
//
//  Created by Mitchel Wassler on 11/28/18.
//  Copyright © 2018 Mitchel Wassler. All rights reserved.
//

import UIKit
import Mapbox

class TripDetailViewController: UIViewController {
    
    public var trip : Trip?
    
    var mapView: MGLMapView?
    
    func createMapView() {
        let mapContainer = UIView()
        mapContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapContainer)
        
        mapContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        mapContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        mapContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        mapContainer.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        let url = URL(string: "mapbox://styles/mwassler/cjoxoqlboc8ur2sqmqwml6jsz")
        let mapView = MGLMapView(frame: mapContainer.frame, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let coords = self.trip!.getTripBoundingBox()
        
        mapView.setCenter(coords[0], zoomLevel: 10, animated: false)
        
     
        
        for point in coords {
            let marker = MGLPointAnnotation()
            marker.coordinate = point
            mapView.addAnnotation(marker)
        }
        self.mapView = mapView
        mapContainer.addSubview(mapView)
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = trip?.title ?? ""
        self.createMapView()
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
