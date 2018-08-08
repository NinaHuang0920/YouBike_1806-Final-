//
//  StationProfileImageView.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/8/8.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit

class StationProfileImageView: UIImageView {

    init() {
        super.init(frame: .zero)
        
        //        image = goTamplateImage
        //        tintColor = UIColor.rgb(red: 58, green: 139, blue: 38)
        contentMode = .scaleAspectFit
        //        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func selectedProfileImage(act: String, num: Int) -> UIImage? {
//        let goTamplateImage = #imageLiteral(resourceName: "goodtogo").withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//        let carefulTamplateImage = #imageLiteral(resourceName: "careful").withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//        let stopTamplateImage = #imageLiteral(resourceName: "stop").withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        if act == "0" {
            let closeTamplateImage = #imageLiteral(resourceName: "Close").withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            image = closeTamplateImage
            tintColor = redColor
        } else {
            switch num {
            case 10...1000:
                let goTamplateImage = #imageLiteral(resourceName: "goodtogo").withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                image = goTamplateImage
                tintColor = greenColor
            case 1...9:
                let carefulTamplateImage = #imageLiteral(resourceName: "careful").withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                image = carefulTamplateImage
                tintColor = orangeColor
            default:
                let stopTamplateImage = #imageLiteral(resourceName: "stop").withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                image = stopTamplateImage
                tintColor = redColor
            }
        }
        return image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
