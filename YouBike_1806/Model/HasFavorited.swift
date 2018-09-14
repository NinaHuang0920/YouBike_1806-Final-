//
//  HasFavorited.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/8/8.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import Foundation

struct HasFavorited {

    let stationId: Int
    let stationName: String
    var hasFavorited: Bool
    
    init(bikeStationInfo: StationInfo, hasFavorited: Bool?) {
            self.stationId = bikeStationInfo.id!
            self.stationName = bikeStationInfo.sna!
            self.hasFavorited = hasFavorited!
    }
    
}
