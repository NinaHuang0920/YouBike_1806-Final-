//
//  PointAnnotation.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/7/30.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import MapKit

struct PointAnnotation {
    
    let bikeStationInfo: BikeStationInfo?

    var annotation = MKPointAnnotation()

    init(bikeStationInfo: BikeStationInfo) {
        self.bikeStationInfo = bikeStationInfo
        self.annotation.title = bikeStationInfo.sna
        let stationId = bikeStationInfo.id! - 1
        self.annotation.subtitle = String(stationId)
        self.annotation.coordinate = bikeStationInfo.locate!
        arrAnnotation.append(self.annotation)
    }
    
}

