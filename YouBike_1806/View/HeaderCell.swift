//
//  HeaderCell.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/9/10.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit

class HeaderCell: BaseCell {
    let headerLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 20)
        lb.text = "共 0 筆資料"
        lb.adjustsFontSizeToFitWidth = true
        lb.backgroundColor = UIColor.darkGray
        lb.textColor = UIColor.white
        return lb
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(headerLabel)
        headerLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}
