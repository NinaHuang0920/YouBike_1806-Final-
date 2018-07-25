//
//  BikeCell.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/19.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit

class BikeCell: BaseCell {
    
    var bikeStationInfo: BikeStationInfo? {
        didSet {
            
            if let stationNameLabelText = bikeStationInfo?.sna, let stationIdNumber = bikeStationInfo?.id {
                stationNameLabel.text = "\(stationNameLabelText) (#\(stationIdNumber))"
            }
            
            if let stationAddsLabelText = bikeStationInfo?.ar {
                stationAddsLabel.text = stationAddsLabelText
            }
            
            if let bikeLabelText = bikeStationInfo?.sbi {
                bikeLabel.text = "可借：\(bikeLabelText)"
            }
            if let parkLabelText = bikeStationInfo?.bemp {
                parkLabel.text = "可還：\(parkLabelText)"
            }
            if let timeLabelText = bikeStationInfo?.mday {
                var timeMinSec = (timeLabelText.dropFirst(8)).dropLast(2)
                timeMinSec.insert(":", at: timeMinSec.index(timeMinSec.endIndex, offsetBy: -2))
                timeLabel.text = "\(timeMinSec)更新"
            }
            if let profileImageNum = bikeStationInfo?.sbi, let stationStatus = bikeStationInfo?.act {
                let bikeNum:Int = Int(profileImageNum)!
                profileImage.image = selectedProfileImage(act: stationStatus, num: bikeNum)
            }
            
            
        }
    }
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        let goTamplateImage = #imageLiteral(resourceName: "goodtogo").withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        let carefulTamplateImage = #imageLiteral(resourceName: "careful").withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        let stopTamplateImage = #imageLiteral(resourceName: "stop").withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        image.image = goTamplateImage
        image.tintColor = UIColor.rgb(red: 58, green: 139, blue: 38)
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let favoriteImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .orange
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let stationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "STATION NAME"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let stationAddsLabel: UILabel = {
        let label = UILabel()
        label.text = "STATION Address"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let labelsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bikeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.rgb(red: 231, green: 179, blue: 70)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = " 可借：23"
        label.textColor = .white
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let parkLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.rgb(red: 109, green: 192, blue: 222)
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = " 可停：37"
        label.textColor = .white
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.rgb(red: 72, green: 131, blue: 173)
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = " 15:33更新"
        label.textColor = .white
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
   override func setupViews() {
    super.setupViews()
    
    self.layer.cornerRadius = 5
    self.layer.masksToBounds = true
    
        backgroundColor = .white
        
        addSubview(profileImage)
        addSubview(favoriteImage)
        addSubview(stationNameLabel)
        addSubview(stationAddsLabel)
        addSubview(labelsContainerView)
        
        profileImage.anchor(top: topAnchor, left: leftAnchor, bottom:  bottomAnchor, right: nil, topConstant: 20, leftConstant: 5, bottomConstant: 20, rightConstant: 0, widthConstant: 35, heightConstant: 0)
        
        favoriteImage.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 10, rightConstant: 10, widthConstant: 60, heightConstant: 0)
        
        stationNameLabel.anchor(top: topAnchor, left: profileImage.rightAnchor, bottom: nil, right: favoriteImage.leftAnchor, topConstant: 5, leftConstant: 7, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 25)
        
        stationAddsLabel.anchor(top: stationNameLabel.bottomAnchor, left: stationNameLabel.leftAnchor, bottom: nil, right: stationNameLabel.rightAnchor, topConstant: -1, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        setupInfoLabels()
    }
    
    func setupInfoLabels() {
        labelsContainerView.anchor(top: stationAddsLabel.bottomAnchor, left: stationAddsLabel.leftAnchor, bottom: bottomAnchor, right: stationAddsLabel.rightAnchor, topConstant: 1, leftConstant: -5, bottomConstant: 3, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        let bikeLabelView = UIView()
        let parkLabelView = UIView()
        let timeLabelView = UIView()
        
        let labelStackView = UIStackView(arrangedSubviews: [bikeLabelView, parkLabelView, timeLabelView])
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.axis = .horizontal
        labelStackView.distribution = .fillEqually
        
        labelsContainerView.addSubview(labelStackView)
        
        labelStackView.anchor(top: labelsContainerView.topAnchor, left: labelsContainerView.leftAnchor, bottom: labelsContainerView.bottomAnchor, right: labelsContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        bikeLabelView.addSubview(bikeLabel)
        bikeLabel.anchor(top: bikeLabelView.topAnchor, left: bikeLabelView.leftAnchor, bottom: bikeLabelView.bottomAnchor, right: bikeLabelView.rightAnchor, topConstant: 0.5, leftConstant: 3, bottomConstant: 1, rightConstant: 3, widthConstant: 0, heightConstant: 0)
        
        parkLabelView.addSubview(parkLabel)
        parkLabel.anchor(top: parkLabelView.topAnchor, left: parkLabelView.leftAnchor, bottom: parkLabelView.bottomAnchor, right: parkLabelView.rightAnchor, topConstant: 0.5, leftConstant: 3, bottomConstant: 1, rightConstant: 3, widthConstant: 0, heightConstant: 0)
        
        timeLabelView.addSubview(timeLabel)
        timeLabel.anchor(top: timeLabelView.topAnchor, left: timeLabelView.leftAnchor, bottom: timeLabelView.bottomAnchor, right: timeLabelView.rightAnchor, topConstant: 0.5, leftConstant: 3, bottomConstant: 1, rightConstant: 3, widthConstant: 0, heightConstant: 0)
    }
}
