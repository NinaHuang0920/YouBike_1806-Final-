//
//  BickingMapViewCell.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/8/3.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit
import MapKit

class BickingMapViewCell: MapViewBaseCell {
    private let parkingCellItem: Int = 0
    
    override func setupViews() {
        super.setupViews()
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
        
        view?.setupPinCalloutView(index: index!, cellItem: parkingCellItem)
        view?.rightCalloutAccessoryView = setupMapNavButton()
        
        return view
    }
}
