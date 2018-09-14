//
//  Time.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/7/24.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import Foundation
import MapKit

class TimeHelper {
    
    static func showUpdateTime(timeString: String) -> String {
        var time = "無法更新時間"
        let timeYear = timeString.dropLast(10)
        let timeMonth = (timeString.dropFirst(4)).dropLast(8)
        let timeDate = (timeString.dropFirst(6)).dropLast(6)
        var timeMinSec = (timeString.dropFirst(8)).dropLast(2)
        timeMinSec.insert(":", at: timeMinSec.index(timeMinSec.endIndex, offsetBy: -2))
        time = "最新時間: \(timeYear).\(timeMonth).\(timeDate). \(timeMinSec)"
        return time
    }
    
    static func showUpdateTimeMS(timeString: String) -> String {
        var time = "00:00 更新"
        var timeMinSec = (timeString.dropFirst(8)).dropLast(2)
        timeMinSec.insert(":", at: timeMinSec.index(timeMinSec.endIndex, offsetBy: -2))
        time = "\(timeMinSec)更新"
        return time
    }
    
    static func showUpdateTimeInDetailView(timeString: String) -> String {
        var time = "無法更新時間"
//        let timeYear = timeString.dropLast(10)
        let timeMonth = (timeString.dropFirst(4)).dropLast(8)
        let timeDate = (timeString.dropFirst(6)).dropLast(6)
        var timeMinSec = (timeString.dropFirst(8)).dropLast(2)
        timeMinSec.insert("時", at: timeMinSec.index(timeMinSec.endIndex, offsetBy: -2))
        time = "最後更新時間：\(timeMonth)月\(timeDate)日\(timeMinSec)分"
        return time
    }
    
//    static func walkingTimeETA(from userLocation: CLLocation, toDestinationCoordinate2D: CLLocationCoordinate2D, complete: @escaping () -> ()) {
////        var etaTime: String = "0分鐘"
//        let markDestination = MKPlacemark(coordinate: toDestinationCoordinate2D)
//        let destMapItem = MKMapItem(placemark: markDestination)
//        let request = MKDirectionsRequest()
//        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
//        request.destination = destMapItem
//        request.requestsAlternateRoutes = false
//        request.transportType = .walking
//        let directions = MKDirections(request: request)
//    
//
//        directions.calculateETA{(etaResponse, error) -> Void in
//            guard error == nil else { return }
//            guard let etaResponse = etaResponse else { return }
//            let totalMin = Int(etaResponse.expectedTravelTime/60)
//    
//               let hour = Int(totalMin/60)
//                let min = Int(totalMin % 60)
////               etaTime = "預計步行時間：\(hour)小時\(min)分鐘"
//            complete(totalMin)
//        }
//
//    
////        return "預計步行時間：\(hour)小時\(min)分鐘"
//    }
    
}
