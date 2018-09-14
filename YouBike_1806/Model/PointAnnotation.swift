//
//  PointAnnotation.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/7/30.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import MapKit

class PointAnnotation: MKPointAnnotation {
    
    let bikeStationInfo: StationInfo?
    
    init(bikeStationInfo: StationInfo) {
        self.bikeStationInfo = bikeStationInfo
        super.init()
        
        self.title = bikeStationInfo.sna
        let stationId = bikeStationInfo.id! - 1
        self.subtitle = String(stationId)
        guard let bikeStationLocate = bikeStationInfo.coordinate2D else { return }
        self.coordinate = bikeStationLocate
    }
}

