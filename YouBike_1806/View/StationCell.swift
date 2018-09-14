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

    var stationController: StationController?
    
    var stationInfos: StationInfo? {
        didSet {
            
            if let stationNameLabelText = stationInfos?.sna, let stationIdNumber = stationInfos?.id {
                stationNameLabel.text = "\(stationNameLabelText) (#\(stationIdNumber))"
            }
            if let stationAddsLabelText = stationInfos?.ar {
                stationAddsLabel.text = stationAddsLabelText
            }
            if let bikeLabelText = stationInfos?.sbi {
                bikeLabel.attributedText = bikeLabel.labealAttributedTex(infosType: InfosType.bikeInfo, inputString: bikeLabelText)
            }
            if let parkLabelText = stationInfos?.bemp {
                parkLabel.attributedText = parkLabel.labealAttributedTex(infosType: InfosType.parkInfo, inputString: parkLabelText)
            }
            if let timeLabelText = stationInfos?.mday {
                timeLabel.text = TimeHelper.showUpdateTimeMS(timeString: timeLabelText)
            }
            if let profileImageNum = stationInfos?.sbi, let stationStatus = stationInfos?.act {
                let bikeNum:Int = Int(profileImageNum)!
                profileImage.image = profileImage.selectedProfileImage(act: stationStatus, num: bikeNum)
            }
            if let distence = stationInfos?.distence {
                let distenceKilometer: Double = Double(distence) / 1000.00
                distanceLabel.text = "\(String(describing: distenceKilometer).dropLast(1)) 公里"
            }
        }
    }
    
    let profileImage = StationProfileImageView()
    let stationNameLabel = StationLabel(stationLabelType: StationLabelType.stationName)
    let stationAddsLabel = StationLabel(stationLabelType: StationLabelType.stationAddress)
    let distanceLabel = StationLabel(stationLabelType: StationLabelType.stationDistance)

    lazy var favoriteButton: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.addTarget(self, action: #selector(handleFavoriteButtonTapped), for: .touchUpInside)
        return btn
    }()
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
    
    @objc func handleFavoriteButtonTapped(sender: UIButton) {
        
        let favoritedId: Int16 = Int16(sender.tag)
        _ = stationController?.updateButtonStatus(by: favoritedId)
        let test = stationController?.filterDataByStationId(stationId: favoritedId)
        _ = test!.map({print("測試 ",$0.stationId,$0.stationName!,$0.hasFavorited) })
        
        (stationController?.filterDataByStationId(stationId: favoritedId)?.first?.hasFavorited)! ? favoriteButton.setImage(#imageLiteral(resourceName: "favstar").withRenderingMode(.alwaysOriginal), for: .normal) : favoriteButton.setImage(#imageLiteral(resourceName: "unfavstar").withRenderingMode(.alwaysOriginal), for: .normal)
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
