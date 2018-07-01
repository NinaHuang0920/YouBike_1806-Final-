//
//  BicycleAnnotationView.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/30.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import MapKit

class BicycleAnnotationView: MKMarkerAnnotationView {
    
static let ReuseID = "bicycleAnnotation"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var annotation: MKAnnotation? {
        didSet {
            //這邊可以分類顏色
        }
    }
    
    //畫圓
    private func drawRatio(availabeNum: Int, wholeColor: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
        return renderer.image { _ in
            // Fill full circle with wholeColor
            wholeColor.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()
            
//            // Fill pie with fractionColor
//            fractionColor?.setFill()
//            let piePath = UIBezierPath()
//            piePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
//                           startAngle: 0, endAngle: (CGFloat.pi * 2.0 * CGFloat(fraction)) / CGFloat(whole),
//                           clockwise: true)
//            piePath.addLine(to: CGPoint(x: 20, y: 20))
//            piePath.close()
//            piePath.fill()
            
            // Fill inner circle with white color
            UIColor.white.setFill()
            UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 24, height: 24)).fill()
            
            // Finally draw count text vertically and horizontally centered
            let attributes = [ NSAttributedStringKey.foregroundColor: UIColor.black,
                               NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)]
            let text = "\(availabeNum)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)
        }
    }

    
    
}
