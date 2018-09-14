//
//  StationLabel.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/8/8.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit

enum StationLabelType {
    case stationName
    case stationAddress
    case stationDistance
    case stationDetailName
    case stationDetailAddress
    case stationDetailOthers
}

class StationLabel: UILabel {
    
    init(stationLabelType: StationLabelType) {
        super.init(frame: .zero)

        backgroundColor = .clear
        adjustsFontSizeToFitWidth = true
        adjustsFontForContentSizeCategory = true
        
        switch stationLabelType {
        case .stationName:
            font = UIFont.boldSystemFont(ofSize: 18)
            textColor = stationTitleLableColor
        case .stationAddress:
            textColor = UIColor.darkGray
            font = UIFont.systemFont(ofSize: 13)
        case .stationDistance:
            font = UIFont.systemFont(ofSize: 14)
            textColor = .black
            textAlignment = .right
        case .stationDetailName:
            font = UIFont.boldSystemFont(ofSize: 28)
            textColor = stationTitleLableColor
        case .stationDetailAddress:
            textColor = UIColor.darkGray
            font = UIFont.systemFont(ofSize: 20)
        case .stationDetailOthers:
            textColor = UIColor.black
            font = UIFont.systemFont(ofSize: 22)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
