//
//  SetService.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/7/31.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import MapKit

class SetService {
    static let sharedInstance = SetService()
    private init() {}
    
//    func getStationService(setCollectionCompletion: @escaping () -> (), messageblock: @escaping () -> ()) {
//        Service.sharedInstance.fetchJsonData(urlString: webString, completion: { (bikeinfos, err) in
//            if let err = err {
//                print("BikeViewController 偵測網路沒開：",err.localizedDescription)
//                messageblock()
////                Alert.showAlert(title: "請開啟網路", message: "更新失敗", vc: self)
//            }
//            guard let bikeinfos = bikeinfos else { stationBikeDatas = []; return }
//
//            if hasFavoritedArray?.count == nil {
//                var favoritedArr = [HasFavorited]()
//                _ = bikeinfos.map{ favoritedArr.append(HasFavorited(bikeStationInfo: $0, hasFavorited: false)) }
//                hasFavoritedArray = favoritedArr
//            }
//
//            stationBikeDatas = bikeinfos.sorted(by: { $0.distence! < $1.distence! })
//            DispatchQueue.main.async {
////                self.collectionView?.reloadData()
//                setCollectionCompletion()
//            }
//            messageblock()
////            Alert.showAlert(title: "下載完成", message: TimeHelper.showUpdateTime(timeString: self.bikeDatas[0].mday!), vc: self)
//        })
//    }
    
    func getStationService(setCollectionCompletion: @escaping () -> (), messageblock: @escaping () -> ()) {
        
        Service.sharedInstance.fetchJsonData(urlString: webString, completion: { (bikeinfos, err) in
            if let err = err {
                print("BikeViewController 偵測網路沒開：",err.localizedDescription)
                messageblock()
//                Alert.showAlert(title: "請開啟網路", message: "更新失敗", vc: self)
            }
            guard let bikeInfos = bikeinfos else { stationBikeDatas = []; return }
            
            let templeteBikeInfos = bikeInfos.sorted(by: { $0.id! < $1.id! })
            
            if bikeInfos.count > 0 && hasFavoritedArray?.count == nil {
                
                var favoritedArr = [HasFavorited]()
                _ = templeteBikeInfos.map{ favoritedArr.append(HasFavorited(bikeStationInfo: $0, hasFavorited: false)) }
                hasFavoritedArray = favoritedArr
                
            } else if bikeInfos.count > 0 && (hasFavoritedArray?.count)! < bikeInfos.count {
                
                let filterArray = templeteBikeInfos.filter({ !hasFavoritedArray!.map({ $0.stationName }).contains($0.sna) })
                _ = filterArray.map({hasFavoritedArray?.append(HasFavorited(bikeStationInfo: $0, hasFavorited: false)) })
                
            } else if bikeInfos.count > 0 && (hasFavoritedArray?.count)! > bikeInfos.count {
                
                let filterArray = hasFavoritedArray?.filter({ !templeteBikeInfos.map({$0.sna}).contains($0.stationName) })
                let templateFilterHasFavoritedArray = hasFavoritedArray?.filter({ return !filterArray!.map({$0.stationName}).contains($0.stationName) })
                hasFavoritedArray?.removeAll()
                hasFavoritedArray = templateFilterHasFavoritedArray
                
            }
            
            if LocationService.sharedInstance.currentLocation != nil {
                stationBikeDatas = bikeInfos.sorted(by: { $0.distence! < $1.distence! })
            } else {
                stationBikeDatas = bikeInfos
            }
            
            DispatchQueue.main.async {
                setCollectionCompletion()
//                self.collectionView?.reloadData()
            }
            messageblock()
            //            Alert.showAlert(title: "下載完成", message: TimeHelper.showUpdateTime(timeString: stationBikeDatas[0].mday!), vc: self)
        })
    }
    

    func getMapService(setPinToMapCompletion: @escaping () -> (), messageblock: @escaping () -> ()) {
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

            print(pointAnnotation.count)
//            print("SetService大頭針數量 mapView annotations",mapView.annotations.count)
            print("SetService大頭針數量 arrAnnotation",arrAnnotation.count)
            setPinToMapCompletion()

            mapNetworkCheck = true //
//            print("SetSerivce 呼叫成功",bikeDatas.count)
            
            let deadline = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                messageblock()
            }
        })
    }
}
