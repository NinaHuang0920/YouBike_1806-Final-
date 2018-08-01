//
//  Json.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/15.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit
import MapKit

struct Top: Decodable {
    var success: Bool?
    var result: BikeResult
}

struct BikeResult: Decodable {
//    let resource_id: String
    let records: [BikeStationInfo]
    let total: Int?
    let limit: Int?
}

class BikeStationInfo: Decodable {
    
    var id: Int?
    var sarea: String?     //場站區域(中文)
//    var sareaen: String?   //場站區域(英文)
    var sna: String?       //站場名稱(中文)
//    var aren: String?      //地址(英文)
    var sno: String?       //站點代號
    var tot: String?       //站場總停車格
//    var snaen: String?     //站場名稱(英文)
    var bemp: String?      //空站數量(可還車位數)
    var ar: String?        //地址(中文)
    var act: String?       //全站禁用狀態(場站暫停營運)
    var lat: String?       //緯度
    var lng: String?       //經度
    var sbi: String?       //場站目前車輛數量
    var mday: String?      //資料更新時間
    var locate:CLLocationCoordinate2D? //lat緯度, lng經度
    
    enum CodingKeys: String, CodingKey {
        case sno, sna, sarea, ar, lat, lng, tot, sbi, bemp, mday, act, sareaen, snaen, aren
        case id = "_id"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        sno = try container.decode(String.self, forKey: .sno)
        sna = try container.decode(String.self, forKey: .sna)
        sarea = try container.decode(String.self, forKey: .sarea)
        ar = try container.decode(String.self, forKey: .ar)
        tot = try container.decode(String.self, forKey: .tot)
        sbi = try container.decode(String.self, forKey: .sbi)
        bemp = try container.decode(String.self, forKey: .bemp)
        mday = try container.decode(String.self, forKey: .mday)
        act = try container.decode(String.self, forKey: .act)
//        sareaen = try container.decode(String.self, forKey: .sareaen)
//        snaen = try container.decode(String.self, forKey: .snaen)
//        aren = try container.decode(String.self, forKey: .aren)
        
        let lat = try container.decode(String.self, forKey: .lat)
        let lng = try container.decode(String.self, forKey: .lng)
        if lat != "" && lng != "" {
             locate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(lng)!)
        }
//        locate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(lng)!)
    }
}

