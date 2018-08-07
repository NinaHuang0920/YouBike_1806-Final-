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
let updateMapViewNotificationName = Notification.Name(rawValue: updateMapViewNotificationKey)
let showNetworkAlertNotificationKey = "com.smilec.showAlert"

var isShowMapSearchResult: Bool = false
var mapSearchArr: [MKAnnotation] = [MKAnnotation]()

class MapViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate, MKMapViewDelegate, UISearchControllerDelegate {

    private let mapViewCellId = "mapViewCellId"
    private let parkMapViewCellId = "parkMapViewCellId"
    private let bickMapViewCellId = "bickMapViewCellId"
    
    let showNetworkAlertName = Notification.Name(rawValue: showNetworkAlertNotificationKey)
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var resultSearchController: UISearchController!
    
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
    
//    var mapViewBaseCell: MapViewBaseCell?
    lazy var mapViewBaseCell: MapViewBaseCell = {
//        let mc = MapViewBaseCell(locationService: LocationService.sharedInstance)
        let mc = MapViewBaseCell()
        mc.mapViewController = self
        return mc
    }()
    
    var mapView: MKMapView?
    
    // MapBar移動的設定
    func scrollToMenuIndex(menuIndex: Int) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: {
            let indexPath = IndexPath(item: menuIndex, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }) { (_) in
            self.setTitleForIndex(index: menuIndex)
        }
       
    }
    // MapBar移動的設定
    private func setTitleForIndex(index: Int) {
        let mapBarTitleText = ["借車地圖","還車地圖"]
        mapBarTitle.text = mapBarTitleText[index]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupMapBarSelectedView()
        setupCollectionView()
        createObservers()
        setupSearchTable()
        print("在MapViewController看mapBaseCell的位置",mapViewBaseCell.self)
    }

    func createObservers() {
         NotificationCenter.default.addObserver(self, selector: #selector(handleNetworkAlert(notification:)), name: showNetworkAlertName, object: nil)
    }
    
    @objc func handleNetworkAlert(notification: NSNotification) {
        if mapNetworkCheck == true {
            Alert.showAlert(title: "下載完成", message: TimeHelper.showUpdateTime(timeString: bikeDatas[0].mday!), vc: self)
        } else if mapNetworkCheck == false {
            Alert.showAlert(title: "請開啟網路", message: "更新失敗", vc: self)
        }
    }
//    @objc func removeNetworkAlert(notification: NSNotification) {
//
//    }
    
    func setupCollectionView() {
        
//        collectionView?.register(MapViewBaseCell.self, forCellWithReuseIdentifier: mapViewCellId)
        collectionView?.register(BickingMapViewCell.self, forCellWithReuseIdentifier: bickMapViewCellId)
        collectionView?.register(ParkingMapViewCell.self, forCellWithReuseIdentifier: parkMapViewCellId)
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
        
        mapBarDataUpdateButton.anchor(top: mapBarSelectedContaner.topAnchor, left: mapBarSelectedContaner.leftAnchor, bottom: mapBarSelectedContaner.bottomAnchor, right: nil, topConstant: 6, leftConstant: 3, bottomConstant: 6, rightConstant: 0, widthConstant: 60, heightConstant: 0)
        
        mapBarLeftToolbar.anchor(top: mapBarSelectedContaner.topAnchor, left: mapBarDataUpdateButton.rightAnchor, bottom: mapBarSelectedContaner.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 65, heightConstant: 0)
    }
    
    var locationSearchTableViewController = LocationSearchTableViewController(style: UITableViewStyle.plain)
//    lazy var locationSearchTableViewController: LocationSearchTableViewController = {
//        let table = LocationSearchTableViewController()
////        table.handleMapSearchDelegate = self.mapViewBaseCell
////        table.mapView = self.mapViewBaseCell.mapView
//        return table
//    }()
    func setupSearchTable() {
        resultSearchController = UISearchController(searchResultsController: locationSearchTableViewController)
        resultSearchController.searchResultsUpdater = locationSearchTableViewController
    }
    
    @objc func handleSearchBarItem() {
        resultSearchController.delegate = self
//        resultSearchController.searchResultsUpdater = locationSearchTableViewController
        resultSearchController.searchBar.delegate = self
        resultSearchController.searchBar.sizeToFit()
        resultSearchController.searchBar.placeholder = "請輸入站點關鍵字"
        resultSearchController.searchBar.becomeFirstResponder()
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        present(resultSearchController, animated: true, completion: nil)
        isShowMapSearchResult = resultSearchController.isActive
        print("MapViewContoller 看到的 Map位置", mapViewBaseCell.mapView.self )
    }
    
    lazy var mapBarDataUpdateButton: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.backgroundColor = mapBarColorBlue
        btn.setTitle("更新", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 3
        btn.addTarget(self, action: #selector(handleMapDataUpdate), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    @objc func handleMapDataUpdate() {
        NotificationCenter.default.post(name: updateMapViewNotificationName, object: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: parkMapViewCellId, for: indexPath) as! ParkingMapViewCell
            print("在MapController cellForItem == parkMapViewCell 看 MapCell的位置",mapViewBaseCell.self)
            return cell
        }
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mapViewCellId, for: indexPath) as! MapViewBaseCell
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bickMapViewCellId, for: indexPath) as! BickingMapViewCell
        print("在MapController cellForItem == bickMapViewCell 看 MapCell的位置",mapViewBaseCell.self)
        
        
         print("在MapController cellForItem == mapViewBaseCell 看 MapCell的位置",mapViewBaseCell.self)
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

extension MapViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.resultSearchController.searchBar.becomeFirstResponder() // close keyborad
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultSearchController.dismiss(animated: true, completion: nil)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        isShowMapSearchResult = false
    }
}
