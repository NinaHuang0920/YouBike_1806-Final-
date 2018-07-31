//
//  Extensions.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/19.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    static func rgba(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
//        return anchors
    }
    
}

extension BikeCell {
    
    func selectedProfileImage(act: String,num: Int) -> UIImage? {
        if act == "0" {
            let closeTamplateImage = #imageLiteral(resourceName: "Close").withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            profileImage.image = closeTamplateImage
            profileImage.tintColor = redColor
        } else {
            switch num {
            case 10...1000:
                let goTamplateImage = #imageLiteral(resourceName: "goodtogo").withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                profileImage.image = goTamplateImage
                profileImage.tintColor = greenColor
            case 1...9:
                let carefulTamplateImage = #imageLiteral(resourceName: "careful").withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                profileImage.image = carefulTamplateImage
                profileImage.tintColor = orangeColor
            default:
                let stopTamplateImage = #imageLiteral(resourceName: "stop").withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                profileImage.image = stopTamplateImage
                profileImage.tintColor = redColor
            }
        }
        return profileImage.image
    }
    
    
}
