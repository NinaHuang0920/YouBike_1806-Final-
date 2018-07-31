//
//  SetMapService.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/7/31.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import MapKit

class SetMapService {
    static let sharedInstance = SetMapService()
    private init() {}
    
    func setMapService(mapView: MKMapView, mapViewController: UICollectionViewController?, setPinToMapCompletion: @escaping () -> (), messageblock: @escaping () -> ()) {
                bikeDatas = []
                arrAnnotation = []
                mapView.removeAnnotations(mapView.annotations)
        
        Service.sharedInstance.fetchJsonData(urlString: webString, completion: { (bikeinfos, err) in
            
            if let err = err {
                mapNetworkCheck = false
                print("MapViewCell 偵測網路沒開：",err.localizedDescription)
                messageblock()
//                self.showNetworkMessageView(mapNetworkCheck: false)
                //                self.setPinToMap()
                setPinToMapCompletion()
            }
            
            guard let bikeinfos = bikeinfos else { return }
            bikeDatas = bikeinfos //
            
            let pointAnnotation = bikeinfos.map{ PointAnnotation(bikeStationInfo: $0)} //
            print(pointAnnotation.count)
            print("SetService大頭針數量",arrAnnotation.count)
            setPinToMapCompletion()
            //            self.setPinToMap()
            mapNetworkCheck = true //
            print("SetSerivce 呼叫成功",bikeDatas.count)
            
            DispatchQueue.main.async {
                mapView.updateConstraints() //
                mapViewController?.collectionView?.reloadData() //
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.5) {
                messageblock()
//                self.showNetworkMessageView(mapNetworkCheck: mapNetworkCheck) //
            }
        })
    }
}
