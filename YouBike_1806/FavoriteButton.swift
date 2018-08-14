//
//  FavoriteButton.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/8/8.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit

//protocol FavoriteButtonDelegate {
//    func favoriteButtonIsTapped(buttonIndex: Int, sender: UIButton)
//}


class FavoriteButton: UIButton {
    
    
//    var favoriteButtonDelegate: FavoriteButtonDelegate!
    
    var isChecked: Bool?
     
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(#imageLiteral(resourceName: "unfavstar"), for: UIControlState.normal)
//        self.setImage(#imageLiteral(resourceName: "favstar"), for: UIControlState.selected)
//        self.addTarget(self, action: #selector(buttonClicked), for: UIControlEvents.touchUpInside)
//        updateImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    @objc func buttonClicked(sender: UIButton) {
//        if sender == self {
//
//            self.isChecked = isChecked == nil ? true : !isChecked!
//            favoriteButtonDelegate.favoriteButtonIsTapped(buttonIndex: sender.tag, sender: sender)
//
//            print("第\(sender.tag)按鈕被按下了 isChcked的值現在是：\(String(describing: isChecked!))")
//        }

//        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear, animations: {
//            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//
//        }) { (success) in
//            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
//                sender.isSelected = !sender.isSelected
//                sender.transform = .identity
//            }, completion: nil)
//        }
//    }
    
    
//    func updateImage() {
//        if isChecked == true {
//           self.setImage(checkImage, for: UIControlState.normal)
//        } else {
//            self.setImage(uncheckImage, for: UIControlState.normal)
//        }
//    }


}
