//
//  SetPinToMap.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/7/31.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import MapKit

class SetPinToMap {
    
    static let sharedInstance = SetPinToMap()
    private init() {}
    
    func setPinToMap(arrAnnotation: [MKAnnotation], in mapView: MKMapView, at mapViewController: UICollectionViewController? ) {
        
        mapView.removeAnnotations(mapView.annotations)
        print("setPin 大頭針加入前map位置:", mapView.self)
        print("setPinToMap大頭針數量 mapView annotations", mapView.annotations.count, mapView.self)
        print("setPinToMap大頭針數量 arrAnnotation", arrAnnotation.count, mapView.self)
        mapView.addAnnotations(arrAnnotation)
        mapView.showAnnotations(arrAnnotation, animated: false)
        print("setPin 大頭針加入後map位置:", mapView.self, mapView.self)
        print("setPinToMap大頭針數量mapView加入annotations後",mapView.annotations.count, mapView.self)
        let viewRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate,3000,3000)
        mapView.setRegion(viewRegion, animated: true)
        LocationService.sharedInstance.startUpdatingHeading()
        
        DispatchQueue.main.async {
            mapView.updateConstraints()
            mapViewController?.collectionView?.reloadData()
        }
       
    }
}
