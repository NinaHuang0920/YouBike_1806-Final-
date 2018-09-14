//
//  StationDetailView.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/8/22.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit
import MapKit

class StationDetailView: UIViewController {

    var stationController: StationController?
    var destinationCoordinate: CLLocationCoordinate2D?
    var userLocation: CLLocation? = LocationService.sharedInstance.currentLocation
    
    var stationInfo: StationInfo? {
        didSet {
            navigationItem.title = stationInfo?.sna
            
            if let stationName = stationInfo?.sna {
                stationDetailNameLabel.text = stationName
            }
            if let stationAddress = stationInfo?.ar {
                stationDetailAddressLable.text = stationAddress
            }
            if let stationBikeNum = stationInfo?.sbi {
                bikeLabel.text = "可借車輛：\(stationBikeNum)"
            }
            if let stationParkNum = stationInfo?.bemp {
                parkLabel.text = "可還車輛：\(stationParkNum)"
            }
            if let distence = stationInfo?.distence {
                let distenceKilometer: Double = Double(distence) / 1000.00
                distenceLabel.text = "距離當前位置：\(String(describing: distenceKilometer).dropLast(1)) 公里"
            }
            if let timeLabelText = stationInfo?.mday {
                updateTimeLabel.text = TimeHelper.showUpdateTimeInDetailView(timeString: timeLabelText)
            }
            if let destinationLocation = stationInfo?.coordinate2D {
                self.destinationCoordinate = destinationLocation
                let markDestination = MKPlacemark(coordinate: destinationLocation)
                let destMapItem = MKMapItem(placemark: markDestination)
                let request = MKDirectionsRequest()
                guard let userLocation = userLocation else { return Alert.showAlert(title: "使用者定位關閉", message: "請至 設定 > 隱私權 > 定位服務 開啟定位服務", vc: self)}
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
                request.destination = destMapItem
                request.requestsAlternateRoutes = false
                request.transportType = .walking
                let directions = MKDirections(request: request)
                directions.calculateETA{(etaResponse, error) -> Void in
                    guard error == nil else { return }
                    guard let etaResponse = etaResponse else { return }
                    let totalMin = Int(etaResponse.expectedTravelTime/60)
                    let hour = Int(totalMin/60)
                    let min = Int(totalMin % 60)
                    self.etaTimeLabel.text = "預計步行時間：\(hour)小時\(min)分鐘"
                }
            }

        }
    }
    
    let stationDetailNameLabel = StationLabel(stationLabelType: StationLabelType.stationDetailName)
    let stationDetailAddressLable = StationLabel(stationLabelType: StationLabelType.stationDetailAddress)
    let dataLabelContainer = UIView()
    let bikeLabel = StationLabel(stationLabelType: StationLabelType.stationDetailOthers)
    let parkLabel = StationLabel(stationLabelType: StationLabelType.stationDetailOthers)
    let distenceLabel = StationLabel(stationLabelType: StationLabelType.stationDetailOthers)
    let etaTimeLabel = StationLabel(stationLabelType: StationLabelType.stationDetailOthers)
    let updateTimeLabel = StationLabel(stationLabelType: StationLabelType.stationDetailOthers)
    
    let buttonsContainer = UIView()
    lazy var favoriteButton: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.backgroundColor = timeLabelColor
        btn.setTitle("加入最愛", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(handleFavoriteList), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    lazy var navigateButton: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.backgroundColor = timeLabelColor
        btn.setTitle("路線導航", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(handleNavigateFunction), for: UIControlEvents.touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(stationDetailNameLabel)
        view.addSubview(stationDetailAddressLable)
        view.addSubview(dataLabelContainer)
        view.addSubview(distenceLabel)
        view.addSubview(etaTimeLabel)
        view.addSubview(updateTimeLabel)
        view.addSubview(buttonsContainer)
        
        stationDetailNameLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 30, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 55)
        stationDetailAddressLable.anchor(top: stationDetailNameLabel.bottomAnchor, left: stationDetailNameLabel.leftAnchor, bottom: nil, right: stationDetailNameLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 45)
        setupDataLabelContainer()
        if stationInfo?.coordinate2D == nil || stationInfo?.distence == nil {
            updateTimeLabel.anchor(top: dataLabelContainer.bottomAnchor, left: dataLabelContainer.leftAnchor, bottom: nil, right: dataLabelContainer.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 45)
        } else {
            distenceLabel.anchor(top: dataLabelContainer.bottomAnchor, left: dataLabelContainer.leftAnchor, bottom: nil, right: dataLabelContainer.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 45)
            etaTimeLabel.anchor(top: distenceLabel.bottomAnchor, left: distenceLabel.leftAnchor, bottom: nil, right: distenceLabel.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 45)
            updateTimeLabel.anchor(top: etaTimeLabel.bottomAnchor, left: etaTimeLabel.leftAnchor, bottom: nil, right: etaTimeLabel.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 45)
        }
        setupButtonsContainer()
    }
    
    func setupButtonsContainer() {
        buttonsContainer.anchor(top: updateTimeLabel.bottomAnchor, left: updateTimeLabel.leftAnchor, bottom: nil, right: updateTimeLabel.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 45)

        let favoriteButtonView = UIView()
        let navigateButtonView = UIView()
        
        let buttonStackView = UIStackView(arrangedSubviews: [favoriteButtonView, navigateButtonView])
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        
        buttonsContainer.addSubview(buttonStackView)
        buttonStackView.anchor(top: buttonsContainer.topAnchor, left: buttonsContainer.leftAnchor, bottom: buttonsContainer.bottomAnchor, right: buttonsContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        favoriteButtonView.addSubview(favoriteButton)
        navigateButtonView.addSubview(navigateButton)
        favoriteButton.anchor(top: favoriteButtonView.topAnchor, left: favoriteButtonView.leftAnchor, bottom: favoriteButtonView.bottomAnchor, right: favoriteButtonView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        navigateButton.anchor(top: navigateButtonView.topAnchor, left: navigateButtonView.leftAnchor, bottom: navigateButtonView.bottomAnchor, right: navigateButtonView.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    @objc func handleFavoriteList(sender: UIButton) {
        let favoritedId: Int16 = Int16(sender.tag)
        stationController?.updateButtonStatus(by: favoritedId)
        
        guard let hasFavorited = stationController?.filterDataByStationId(stationId: favoritedId)?.first?.hasFavorited else { return }
        hasFavorited ? favoriteButton.setTitle("移除最愛", for: .normal) : favoriteButton.setTitle("加入最愛", for: .normal)
        stationController?.collectionView?.reloadData()
    }
    
    @objc func handleNavigateFunction() {
        let currentMapItem = MKMapItem.forCurrentLocation()
        guard let destination = destinationCoordinate else { return Alert.showAlert(title: "無法取得使用者位置", message: "重新開啟應用程式", vc: self) }
        let markDestination = MKPlacemark(coordinate: destination)
        let destMapItem = MKMapItem(placemark: markDestination)
        destMapItem.name = "導航終點"
        let arrNavi = [currentMapItem,destMapItem]
        let optionNavi = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking]
        MKMapItem.openMaps(with: arrNavi, launchOptions: optionNavi)
    }
    
    func setupDataLabelContainer() {
        dataLabelContainer.anchor(top: stationDetailAddressLable.bottomAnchor, left: stationDetailAddressLable.leftAnchor, bottom: nil, right: stationDetailAddressLable.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 45)
        
        let labelStackView = UIStackView(arrangedSubviews: [bikeLabel, parkLabel])
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.axis = .horizontal
        labelStackView.distribution = .fillEqually
        
        dataLabelContainer.addSubview(labelStackView)
        labelStackView.anchor(top: dataLabelContainer.topAnchor, left: dataLabelContainer.leftAnchor, bottom: dataLabelContainer.bottomAnchor, right: dataLabelContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}
