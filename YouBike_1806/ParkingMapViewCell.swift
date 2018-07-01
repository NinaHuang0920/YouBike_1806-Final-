//
//  MapViewCell.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/29.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit
import MapKit

class ParkingMapViewCell: MapViewBaseCell {
    
    private let cellItem: Int = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin") as? MKPinAnnotationView
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
        }
        let index = Int((annotation.subtitle!)!)

        view?.setupPinCalloutView(index: index!, cellItem: cellItem)
        return view
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

