//
//  ProfileCollectionViewCell.swift
//  travelapp
//
//  Created by Mitchel Wassler on 11/25/18.
//  Copyright © 2018 Mitchel Wassler. All rights reserved.
//

import UIKit
import Mapbox

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    
    var mapView: MGLMapView?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let map = self.mapView {
            map.removeFromSuperview()
            self.mapView = nil
        }
        
    }
    
    func displayContent(trip : Trip) {
        self.cellLabel.text = trip.title
        let url = URL(string: "mapbox://styles/mwassler/cjoxoqlboc8ur2sqmqwml6jsz")
        let mapView = MGLMapView(frame: self.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let coords = trip.getTripBoundingBox()
        
        mapView.setCenter(coords[0], zoomLevel: Double(coords.count), animated: false)
        
        mapView.setVisibleCoordinates(
            coords,
            count: UInt(coords.count),
            edgePadding: UIEdgeInsets(top: 25, left: 25, bottom: 50, right: 25),
            animated: true
        )
        
        for point in coords {
            let marker = MGLPointAnnotation()
            marker.coordinate = point
            mapView.addAnnotation(marker)
        }
        self.mapView = mapView
        self.addSubview(self.mapView!)
        self.sendSubviewToBack(self.mapView!)
    }
}
