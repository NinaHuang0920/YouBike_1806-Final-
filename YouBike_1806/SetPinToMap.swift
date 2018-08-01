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
        
        //        arrAnnotation = []
        //        let bikeDataCount = bikeDatas.count
        //        print("MAP PIN bikeDataCount",bikeDataCount)
        //        for item in 0 ..< bikeDataCount {
        //            let annottaion = MKPointAnnotation()
        //            annottaion.coordinate = bikeDatas[item].locate!
        //            annottaion.title = "\(bikeDatas[item].sna!)"
        //            annottaion.subtitle = "\(bikeDatas[item].id!-1)"
        //            arrAnnotation.append(annottaion)
        //        }
        //        print(arrAnnotation[1].title)
        
        print("setPinToMap大頭針數量",arrAnnotation.count)
        mapView.addAnnotations(arrAnnotation)
        mapView.showAnnotations(arrAnnotation, animated: false)
        
        let viewRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate,3000,3000)
        mapView.setRegion(viewRegion, animated: true)
        //        locationManager.startUpdatingHeading()
        LocationService.sharedInstance.startUpdatingHeading()
        mapView.updateConstraints()
        mapViewController?.collectionView?.reloadData()
    }
    
    
}
