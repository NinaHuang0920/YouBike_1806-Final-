//
//  GeneralSetting.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/20.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit

let stationBarColor = UIColor.rgb(red: 250, green: 246, blue: 227)
let stationTitleColor = UIColor.rgb(red: 190, green: 83, blue: 43)
let mapBarColorBlue = UIColor.rgb(red: 37, green: 126, blue: 255)

let greenColor =  UIColor.rgb(red: 58, green: 139, blue: 38)
let orangeColor = UIColor.rgb(red: 255, green: 145, blue: 0)
let redColor = UIColor.rgb(red: 228, green: 26, blue: 12)

let greenColorWithAlpha =  UIColor.rgba(red: 58, green: 139, blue: 38, alpha: 0.7)
let orangeColorWithAlpha = UIColor.rgba(red: 255, green: 145, blue: 0, alpha: 0.8)
let redColorWithAlpha = UIColor.rgba(red: 228, green: 26, blue: 12, alpha: 0.6)


let selectedMapBarItemColor = UIColor.rgb(red: 148, green: 148, blue: 148)
let mainViewBackgroundColor =  UIColor(white: 0.88, alpha: 1)
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    func setupViews() {
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
