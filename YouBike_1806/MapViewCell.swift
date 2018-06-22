//
//  MapViewCell.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/21.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit
import MapKit

class MapViewCell: BaseCell, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.delegate = self
        return sb
    }()
    
    lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.delegate = self
        return mv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(searchBar)
        addSubview(mapView)

        searchBar.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 56)
        
        mapView.anchor(top: searchBar.bottomAnchor, left: searchBar.leftAnchor, bottom: bottomAnchor, right: searchBar.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
}

//extension MapViewCell: CLLocationManagerDelegate {
//
//
//}
//
//extension MapViewCell: UISearchBarDelegate {
//    lazy var searchBar: UISearchBar = {
//        let sb = UISearchBar()
//        sb.delegate = self
//        return sb
//    }
//
//}
//
//extension MapViewCell: MKMapViewDelegate {
//    lazy var mapView: MKMapView = {
//        let mv = MKMapView()
//        mv.delegate = self
//        return mv
//    }()
//
//}
