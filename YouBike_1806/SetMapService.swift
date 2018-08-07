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

    func setMapService(setPinToMapCompletion: @escaping () -> (), messageblock: @escaping () -> ()) {
                bikeDatas = []
        
        Service.sharedInstance.fetchJsonData(urlString: webString, completion: { (bikeinfos, err) in
            arrAnnotation = []
            if let err = err {
                mapNetworkCheck = false
                print("MapViewCell 偵測網路沒開：",err.localizedDescription)
                setPinToMapCompletion()
                messageblock()
            }
            
            guard let bikeinfos = bikeinfos else { return }
            bikeDatas = bikeinfos //
            
            let pointAnnotation = bikeinfos.map{
                arrAnnotation.append(PointAnnotation(bikeStationInfo: $0))
            }
//            print("setService map位置:", mapView.self)
            print(pointAnnotation.count)
//            print("SetService大頭針數量 mapView annotations",mapView.annotations.count)
            print("SetService大頭針數量 arrAnnotation",arrAnnotation.count)
            setPinToMapCompletion()

            mapNetworkCheck = true //
//            print("SetSerivce 呼叫成功",bikeDatas.count)
            
//            DispatchQueue.main.async {
//                mapView.updateConstraints() //
//                mapViewController?.collectionView?.reloadData() //
//            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.5) {
                messageblock()
            }
        })
    }
}
