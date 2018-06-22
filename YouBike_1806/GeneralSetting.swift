//
//  GeneralSetting.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/20.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit

let stationBarColor = UIColor.rgb(red: 250, green: 246, blue: 227)
let mapBarColor = UIColor.rgb(red: 37, green: 126, blue: 245)
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
