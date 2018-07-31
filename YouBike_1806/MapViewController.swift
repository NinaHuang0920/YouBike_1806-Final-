//
//  BikeMapView.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/20.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit
import MapKit

var bikeDatas = [BikeStationInfo]()

class MapViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate, MKMapViewDelegate {

    private let mapViewCellId = "mapViewCellId"
   private let bikeMapViewCellId = "bikeMapViewCellId"
    
//     var refreshControl = UIRefreshControl()
    
    let mapBarSelectedContaner: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.backgroundColor = .clear
        return view
    }()
    
    let mapBarTitle: UILabel = {
        let lb = UILabel()
        lb.text = "借車地圖"
        lb.font = UIFont.boldSystemFont(ofSize: 22)
        lb.textColor = mapBarColorBlue
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    // MapBar移動的設定
    lazy var mapBarSelectedView: MapBarSelectedView = {
        let mb = MapBarSelectedView()
        mb.mapViewController = self
        return mb
    }()
    
    lazy var mapBarLeftToolbar: UIToolbar = {
        let tb = UIToolbar()
        tb.barTintColor = stationBarColor
        tb.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.any)
        return tb
    }()
    
////    var mapViewBaseCell: MapViewBaseCell?
    lazy var mapViewBaseCell: MapViewBaseCell = {
//        let mc = MapViewBaseCell(locationService: LocationService.sharedInstance)
        let mc = MapViewBaseCell()
        mc.mapView.delegate = self
//        mc.locationManager.delegate = self
        mc.mapViewController = self
//        mc.mapViewCellDelegate = self
        return mc
    }()
    
    // MapBar移動的設定
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        setTitleForIndex(index: menuIndex)
    }
    // MapBar移動的設定
    private func setTitleForIndex(index: Int) {
        let mapBarTitleText = ["借車地圖","還車地圖"]
        mapBarTitle.text = mapBarTitleText[index]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        mapViewBaseCell.mapViewCellDelegate = self
        setupNavBar()
        setupMapBarSelectedView()
        setupCollectionView()
    }

    func setupCollectionView() {
        collectionView?.register(MapViewBaseCell.self, forCellWithReuseIdentifier: mapViewCellId)
        collectionView?.register(ParkingMapViewCell.self, forCellWithReuseIdentifier: bikeMapViewCellId)
        collectionView?.backgroundColor = mainViewBackgroundColor
        collectionView?.isPagingEnabled = true // MapBar移動的設定
    }
    
   // MapBar移動的設定
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mapBarSelectedView.horizontalLeftAnchorConstraint?.constant = scrollView.contentOffset.x * 0.15  // width * 0.3 / 2
    }
    // MapBar移動的設定
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        print(targetContentOffset.pointee.x / view.frame.width)
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        mapBarSelectedView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        setTitleForIndex(index: Int(index))
//        mapViewBaseCell.mapViewItem = Int(index)
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.barTintColor = stationBarColor
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.titleView = mapBarSelectedContaner
    }
    
    func setupMapBarSelectedView() {
        
        let searchButton =  UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(handleSearchBarItem))
        mapBarLeftToolbar.items = [searchButton]
        
        mapBarSelectedContaner.addSubview(mapBarSelectedView)
        mapBarSelectedContaner.addSubview(mapBarTitle)
        mapBarSelectedContaner.addSubview(mapBarLeftToolbar)
        mapBarSelectedContaner.addSubview(mapBarDataUpdateButton)
        
        mapBarSelectedView.anchor(top: mapBarSelectedContaner.topAnchor, left: nil, bottom: mapBarSelectedContaner.bottomAnchor, right: mapBarSelectedContaner.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: screenWidth*0.3, heightConstant: 0)
        mapBarTitle.centerYAnchor.constraint(equalTo: mapBarSelectedContaner.centerYAnchor).isActive = true
        mapBarTitle.centerXAnchor.constraint(equalTo: mapBarSelectedContaner.centerXAnchor).isActive = true
        
//        mapBarDataUpdateButton.anchor(top: mapBarSelectedContaner.topAnchor, left: mapBarSelectedContaner.leftAnchor, bottom: mapBarSelectedContaner.bottomAnchor, right: nil, topConstant: 6, leftConstant: 3, bottomConstant: 6, rightConstant: 0, widthConstant: 60, heightConstant: 0)
        
        mapBarLeftToolbar.anchor(top: mapBarSelectedContaner.topAnchor, left: mapBarSelectedContaner.leftAnchor, bottom: mapBarSelectedContaner.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 65, heightConstant: 0)
        
        mapBarDataUpdateButton.anchor(top: mapBarSelectedContaner.topAnchor, left: mapBarLeftToolbar.rightAnchor, bottom: mapBarSelectedContaner.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 65, heightConstant: 38)
    }
    
//    let searchController = UISearchController(searchResultsController: nil)
//    var searchActive: Bool = false
//    var isShowSearchResult: Bool = false
//    var searchArr: [BikeStationInfo] = [BikeStationInfo]() {
//        didSet {
//            self.collectionView?.reloadData()
//        }
//    }
    
    lazy var mapBarDataUpdateButton: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.backgroundColor = mapBarColorBlue
        btn.setTitle("更新", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 3
        btn.addTarget(self, action: #selector(handleMapDataUpdate), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    @objc func handleSearchBarItem() {

    }
    
    @objc func handleMapDataUpdate() {
        
        print("Map Controller Btn Pressed")
        
        SetMapService.sharedInstance.setMapService(mapView: mapViewBaseCell.mapView, mapViewController: self, setPinToMapCompletion: {
            SetPinToMap.sharedInstance.setPinToMap(arrAnnotation: arrAnnotation, in: self.mapViewBaseCell.mapView, at: self)
        }, messageblock: {
            Alert.showAlert(title: "這是測試", message: "", vc: self)
        })
        

    }
    

  
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bikeMapViewCellId, for: indexPath) as! ParkingMapViewCell
            return cell
        }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mapViewCellId, for: indexPath) as! MapViewBaseCell
            return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
 
    }
}

//extension MapViewController: MapViewCellDelegate {
//
//    func updateStatusAlert(status updateSuccess: Bool) {
//        if updateSuccess == true {
//            Alert.showAlert(title: "下載完成", message: TimeHelper.showUpdateTime(timeString: bikeDatas[0].mday!), vc: self)
//        } else if updateSuccess == false {
//            Alert.showAlert(title: "請開啟網路", message: "更新失敗", vc: self)
//        }
//    }
//}

//extension MapViewController {
//func setupRefreshControl() {
//    refreshControl.addTarget(self, action: #selector(refreshContents), for: .valueChanged)
//    if #available(iOS 10.0, *) {
//        collectionView?.refreshControl = refreshControl
//    } else {
//        collectionView?.addSubview(refreshControl)
//    }
//}
//
//@objc func refreshContents() {
//    refreshControl.attributedTitle = NSAttributedString(string: "資料更新中")
//    bikeDatas.removeAll()
//    mapViewBaseCell.SetService()
//    self.collectionView?.reloadData()
//    self.perform(#selector(finishedRefreshing), with: nil, afterDelay: 1.5)
//}
//
//@objc func finishedRefreshing() {
//    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//        self.refreshControl.attributedTitle = NSAttributedString(string: "資料更新完成")
//    }, completion: { _ in
//        self.refreshControl.endRefreshing()
//
//        if bikeDatas.count == 0 {
//            Alert.showAlert(title: "請檢查網路", message: "", vc: self)
//        }
//    })
//}
//}
