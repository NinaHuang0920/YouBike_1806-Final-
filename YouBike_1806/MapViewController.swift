//
//  BikeMapView.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/20.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit
import MapKit

 var bikeDatas: [BikeStationInfo]?

class MapViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {

    private let mapViewCellId = "mapViewCellId"
   private let bikeMapViewCellId = "bikeMapViewCellId"
    
    let mapBarSelectedContaner: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.backgroundColor = .clear
        return view
    }()
    
    let mapBarTitle: UILabel = {
        let lb = UILabel()
        lb.text = "借車地圖"
        lb.font = UIFont.boldSystemFont(ofSize: 22)
        lb.textColor = mapBarColor
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    // MapBar移動的設定
    lazy var mapBarSelectedView: MapBarSelectedView = {
        let mb = MapBarSelectedView()
        mb.mapViewController = self
        return mb
    }()
    
    lazy var mapViewBaseCell: MapViewBaseCell = {
        let mc = MapViewBaseCell()
        mc.mapViewController = self
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
        setupNavBar()
        setupMapBarSelectedView()
        collectionView?.register(MapViewBaseCell.self, forCellWithReuseIdentifier: mapViewCellId)
//        collectionView?.register(ParkingMapViewCell.self, forCellWithReuseIdentifier: bikeMapViewCellId)
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
        mapViewBaseCell.mapViewItem = Int(index)
    }
    
    func setupNavBar() {
        navigationItem.title = "地圖"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 22)]
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 250, green: 246, blue: 227)
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.titleView = mapBarSelectedContaner
    }
    
    func setupMapBarSelectedView() {
        mapBarSelectedContaner.addSubview(mapBarSelectedView)
        mapBarSelectedContaner.addSubview(mapBarTitle)
        
        mapBarSelectedView.anchor(top: mapBarSelectedContaner.topAnchor, left: nil, bottom: mapBarSelectedContaner.bottomAnchor, right: mapBarSelectedContaner.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: screenWidth*0.3, heightConstant: 0)
        mapBarTitle.centerYAnchor.constraint(equalTo: mapBarSelectedContaner.centerYAnchor).isActive = true
        mapBarTitle.centerXAnchor.constraint(equalTo: mapBarSelectedContaner.centerXAnchor).isActive = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        if indexPath.item == 1 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bikeMapViewCellId, for: indexPath) as! ParkingMapViewCell
//            return cell
//        }
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

