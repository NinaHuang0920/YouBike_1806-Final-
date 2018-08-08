//
//  BikeCell.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/19.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit
import MapKit

class StationCell: BaseCell {
    
    var bikeStationInfo: BikeStationInfo? {
        didSet {
            
            if let stationNameLabelText = bikeStationInfo?.sna, let stationIdNumber = bikeStationInfo?.id {
                stationNameLabel.text = "\(stationNameLabelText) (#\(stationIdNumber))"
            }
            if let stationAddsLabelText = bikeStationInfo?.ar {
                stationAddsLabel.text = stationAddsLabelText
            }
            if let bikeLabelText = bikeStationInfo?.sbi {
                bikeLabel.attributedText = bikeLabel.labealAttributedTex(infosType: InfosType.bikeInfo, inputString: bikeLabelText)
            }
            if let parkLabelText = bikeStationInfo?.bemp {
                parkLabel.attributedText = parkLabel.labealAttributedTex(infosType: InfosType.parkInfo, inputString: parkLabelText)
            }
            if let timeLabelText = bikeStationInfo?.mday {
                timeLabel.text = TimeHelper.showUpdateTimeMS(timeString: timeLabelText)
            }
            if let profileImageNum = bikeStationInfo?.sbi, let stationStatus = bikeStationInfo?.act {
                let bikeNum:Int = Int(profileImageNum)!
                profileImage.image = profileImage.selectedProfileImage(act: stationStatus, num: bikeNum)
            }
            if let distance = bikeStationInfo?.distence {
                let distanceKilometer: Double = Double(distance) / 1000.00
                distanceLabel.text = "\(String(describing: distanceKilometer).dropLast(1)) 公里"
            }
        }
    }
    
    let profileImage = StationProfileImageView()
    let stationNameLabel = StationLabel(stationLabelType: StationLabelType.stationName)
    let stationAddsLabel = StationLabel(stationLabelType: StationLabelType.stationAddress)
    let distanceLabel = StationLabel(stationLabelType: StationLabelType.stationDistance)
    let favoriteButton = FavoriteButton()
    let infosLabelContainer = UIView()
    let bikeLabel = StationInfosLabel(labelColor: LabelColorType.bikeLabelColor)
    let parkLabel = StationInfosLabel(labelColor: LabelColorType.parkLabelColor)
    let timeLabel = StationInfosLabel(labelColor: LabelColorType.timeLabelColor)
    
   override func setupViews() {
    super.setupViews()
    
    self.layer.cornerRadius = 5
    self.layer.masksToBounds = true
    
    backgroundColor = .white
        
    addSubview(profileImage)
    addSubview(stationNameLabel)
    addSubview(stationAddsLabel)
    addSubview(infosLabelContainer)
    addSubview(distanceLabel)
    addSubview(favoriteButton)
    
    profileImage.anchor(top: topAnchor, left: leftAnchor, bottom:  bottomAnchor, right: nil, topConstant: 20, leftConstant: 5, bottomConstant: 20, rightConstant: 0, widthConstant: 35, heightConstant: 0)
    stationNameLabel.anchor(top: topAnchor, left: profileImage.rightAnchor, bottom: nil, right: distanceLabel.leftAnchor, topConstant: 5, leftConstant: 7, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 25)
    stationAddsLabel.anchor(top: stationNameLabel.bottomAnchor, left: stationNameLabel.leftAnchor, bottom: nil, right: stationNameLabel.rightAnchor, topConstant: -1, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
    distanceLabel.anchor(top: topAnchor, left: stationAddsLabel.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 3, leftConstant: 0, bottomConstant: 0, rightConstant: 2, widthConstant: 60, heightConstant: 35)
    favoriteButton.anchor(top: distanceLabel.bottomAnchor, left: distanceLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    setupInfoLabels()
    }
    
    func setupInfoLabels() {
        infosLabelContainer.anchor(top: stationAddsLabel.bottomAnchor, left: stationAddsLabel.leftAnchor, bottom: bottomAnchor, right: stationAddsLabel.rightAnchor, topConstant: 1, leftConstant: -5, bottomConstant: 3, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        let bikeLabelView = UIView()
        let parkLabelView = UIView()
        let timeLabelView = UIView()
        
        let labelStackView = UIStackView(arrangedSubviews: [bikeLabelView, parkLabelView, timeLabelView])
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.axis = .horizontal
        labelStackView.distribution = .fillEqually
        
        infosLabelContainer.addSubview(labelStackView)
        
        labelStackView.anchor(top: infosLabelContainer.topAnchor, left: infosLabelContainer.leftAnchor, bottom: infosLabelContainer.bottomAnchor, right: infosLabelContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        bikeLabelView.addSubview(bikeLabel)
        bikeLabel.anchor(top: bikeLabelView.topAnchor, left: bikeLabelView.leftAnchor, bottom: bikeLabelView.bottomAnchor, right: bikeLabelView.rightAnchor, topConstant: 0.5, leftConstant: 3, bottomConstant: 1, rightConstant: 3, widthConstant: 0, heightConstant: 0)
        
        parkLabelView.addSubview(parkLabel)
        parkLabel.anchor(top: parkLabelView.topAnchor, left: parkLabelView.leftAnchor, bottom: parkLabelView.bottomAnchor, right: parkLabelView.rightAnchor, topConstant: 0.5, leftConstant: 3, bottomConstant: 1, rightConstant: 3, widthConstant: 0, heightConstant: 0)
        
        timeLabelView.addSubview(timeLabel)
        timeLabel.anchor(top: timeLabelView.topAnchor, left: timeLabelView.leftAnchor, bottom: timeLabelView.bottomAnchor, right: timeLabelView.rightAnchor, topConstant: 0.5, leftConstant: 3, bottomConstant: 1, rightConstant: 3, widthConstant: 0, heightConstant: 0)
    }
}
