//
//  SetService.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/7/31.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import MapKit

class GetService {

    static let sharedInstance = GetService()
    private init() {}
    
    func getStationService(coreDataHandler: @escaping ([StationInfo]) -> ()  , collectionViewReloadHandler: @escaping () -> (), messageblock: @escaping () -> ()) {
        
        NetworkService.sharedInstance.fetchJsonData(urlString: taoyuanWebString, completion: { (stationInfos, err) in
            if let err = err {
                print("BikeViewController 偵測網路沒開：",err.localizedDescription)
                messageblock()
            }
            
            guard let stationInfos = stationInfos else { stationDatas = []; return }
            let sortedStationIdInfos = stationInfos.sorted(by: { $0.id! < $1.id! })
            
            if LocationService.sharedInstance.currentLocation != nil {
                stationDatas = stationInfos.sorted(by: { $0.distence! < $1.distence! })
            } else {
                stationDatas = stationInfos
            }
            
            coreDataHandler(sortedStationIdInfos)
            
            DispatchQueue.main.async {
                collectionViewReloadHandler()
            }
            messageblock()
        })
    }
    

    func getMapService(setPinToMapCompletion: @escaping () -> (), messageblock: @escaping () -> ()) {
                bikeDatas = []
        
        NetworkService.sharedInstance.fetchJsonData(urlString: taoyuanWebString, completion: { (bikeinfos, err) in
            arrAnnotation = []
            if let err = err {
                mapNetworkCheck = false
                print("MapViewCell 偵測網路沒開：",err.localizedDescription)
                DispatchQueue.main.async {
                    setPinToMapCompletion()
                    messageblock()
                }
            }
            
            guard let bikeinfos = bikeinfos else { return }
            bikeDatas = bikeinfos //
            
            let pointAnnotation = bikeinfos.map{
                arrAnnotation.append(PointAnnotation(bikeStationInfo: $0))
            }

            print(pointAnnotation.count)
//            print("SetService大頭針數量 mapView annotations",mapView.annotations.count)
            print("SetService大頭針數量 arrAnnotation",arrAnnotation.count)
            DispatchQueue.main.async {
                setPinToMapCompletion()
                mapNetworkCheck = true //
            }
//            print("SetSerivce 呼叫成功",bikeDatas.count)
            let deadline = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                messageblock()
            }
        })
    }
}
