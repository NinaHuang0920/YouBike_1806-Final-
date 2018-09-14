//
//  InfosLabel.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/8/8.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit

enum LabelColorType {
    case bikeLabelColor
    case parkLabelColor
    case timeLabelColor
}

enum InfosType: String {
    case bikeInfo = "可借："
    case parkInfo = "可還："
}

class StationInfosLabel: UILabel {

    init(labelColor: LabelColorType) {
        super.init(frame: .zero)
        
        font = UIFont.boldSystemFont(ofSize: 16)
        textAlignment = .center
        text = " 可借：23"
        textColor = .white
        layer.cornerRadius = 4
        layer.masksToBounds = true
        adjustsFontSizeToFitWidth = true
        
        switch labelColor {
        case .bikeLabelColor:
            backgroundColor = UIColor.rgb(red: 231, green: 179, blue: 70)
        case .parkLabelColor:
            backgroundColor = UIColor.rgb(red: 109, green: 192, blue: 222)
        case .timeLabelColor:
            backgroundColor = UIColor.rgb(red: 72, green: 131, blue: 173)
        }
    }
    
    func labealAttributedTex(infosType: InfosType ,inputString: String) -> NSAttributedString {
        
        let labelMark = NSMutableAttributedString(string: infosType.rawValue, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        labelMark.append(labelTextColor(labelString: inputString))
        return labelMark
    }
    
    func labelTextColor(labelString: String) -> NSAttributedString  {
        var  attributedText: NSAttributedString
        switch labelString {
        case "0","1","2","3":
            attributedText = NSMutableAttributedString(string: "\(labelString)", attributes: [NSAttributedStringKey.foregroundColor : redColor])
        case "4","5","6","7","8","9":
            attributedText = NSMutableAttributedString(string: "\(labelString)", attributes: [NSAttributedStringKey.foregroundColor : UIColor.orange])
        default:
            attributedText = NSMutableAttributedString(string: "\(labelString)", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        }
        
        return attributedText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
