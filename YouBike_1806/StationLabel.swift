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
            textColor = stationTitleColor
        case .stationAddress:
            textColor = UIColor.darkGray
            font = UIFont.systemFont(ofSize: 13)
        case .stationDistance:
            font = UIFont.systemFont(ofSize: 14)
            textColor = .black
            textAlignment = .right
        }
    }
    
    
//    let stationNameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "STATION NAME"
//        label.font = UIFont.boldSystemFont(ofSize: 18) //
//        label.textColor = stationTitleColor //
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.adjustsFontSizeToFitWidth = true
//        label.adjustsFontForContentSizeCategory = true
//        return label
//    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
