//
//  HasFavorited.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/8/8.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import Foundation

struct HasFavorited {
    
//    var bikeStationInfo: BikeStationInfo
    let stationId: Int
    let stationName: String
    var hasFavorited: Bool
    
    init(bikeStationInfo: BikeStationInfo, hasFavorited: Bool?) {
//        self.bikeStationInfo = bikeStationInfo
            self.stationId = bikeStationInfo.id!
            self.stationName = bikeStationInfo.sna!
            self.hasFavorited = hasFavorited!
    }
    
    
//    init(stationId: Int, stationName: String) {
//        self.stationId = stationId
//        self.stationName = stationName
//        self.hasFavorited = false
//    }
    
}
