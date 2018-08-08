//
//  FavoriteButton.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/8/8.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit

class FavoriteButton: UIButton {

    var favoriteImage = #imageLiteral(resourceName: "like").withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    
    var isChecked: Bool = false {
        didSet {
            updateImage()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(favoriteImage, for: UIControlState.normal)
        self.addTarget(self, action: #selector(buttonClicked), for: UIControlEvents.touchUpInside)
        updateImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
    
    
    func updateImage() {
        if isChecked == true {
            self.tintColor = redColorWithAlpha
        } else {
            self.tintColor = UIColor(white: 0.8, alpha: 0.5)
        }
    }
    
//    let favoriteButton: UIButton = {
//        let btn = UIButton(type: UIButtonType.system)
//        btn.setImage(#imageLiteral(resourceName: "like"), for: .normal)
//        btn.tintColor = redColor
//        btn.backgroundColor = .clear
//        btn.addTarget(self, action: #selector(handleFavoriateBtn), for: .touchUpInside)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
