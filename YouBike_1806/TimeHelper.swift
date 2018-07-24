//
//  Time.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/7/24.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import Foundation

class TimeHelper {
    
    static func showUpdateTime(timeString: String) -> String {
        let timeYear = timeString.dropLast(10)
        let timeMonth = (timeString.dropFirst(4)).dropLast(8)
        let timeDate = (timeString.dropFirst(6)).dropLast(6)
        var timeMinSec = (timeString.dropFirst(8)).dropLast(2)
        timeMinSec.insert(":", at: timeMinSec.index(timeMinSec.endIndex, offsetBy: -2))
        let time = "最新時間: \(timeYear).\(timeMonth).\(timeDate). \(timeMinSec)"
        return time
    }
    
}
