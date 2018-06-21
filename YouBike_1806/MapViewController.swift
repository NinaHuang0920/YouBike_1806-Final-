//
//  BikeMapView.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/20.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit

class MapViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let mapViewCellId = "mapViewCellId"
    let mapBarTitleText = ["借車地圖","還車地圖"]
    
    let mapBarSelectedContaner: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.backgroundColor = .clear
        return view
    }()
    
    let mapBarTitle: UILabel = {
        let lb = UILabel()
        lb.text = "借車地圖"
        lb.font = UIFont.boldSystemFont(ofSize: 22)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
//    let mapBarSelectedView = MapBarSelectedView()
    // MapBar移動的設定
    lazy var mapBarSelectedView: MapBarSelectedView = {
        let mb = MapBarSelectedView()
        mb.mapViewController = self
        return mb
    }()
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        setTitleForIndex(index: menuIndex)
    }
    
    private func setTitleForIndex(index: Int) {
        mapBarTitle.text = mapBarTitleText[index]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupMapBarSelectedView()
        setupMapBarSelectedView()
        
        collectionView?.register(MapViewCell.self, forCellWithReuseIdentifier: mapViewCellId)
        collectionView?.backgroundColor = mainViewBackgroundColor
        
        collectionView?.isPagingEnabled = true // MapBar移動的設定
    }
   
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.x)
        
//        let ratio = (mapBarSelectedContaner.frame.width*0.3)/scrollView.contentOffset.x
        
//        let ratio = mapBarSelectedVi ew.frame.width / scrollView.contentOffset.x
        mapBarSelectedView.horizontalLeftAnchorConstraint?.constant = scrollView.contentOffset.x * 0.15
        //(scrollView.contentOffset.x) * ratio * 0.5
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        print(targetContentOffset.pointee.x / view.frame.width)
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        mapBarSelectedView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        setTitleForIndex(index: Int(index))
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
        
//        mapBarSelectedView.anchor(top: mapBarSelectedContaner.topAnchor, left: mapBarSelectedContaner.leftAnchor, bottom: mapBarSelectedContaner.bottomAnchor, right: mapBarSelectedContaner.rightAnchor, topConstant: 0, leftConstant: mapBarSelectedContaner.frame.width*0.7, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        mapBarTitle.centerYAnchor.constraint(equalTo: mapBarSelectedContaner.centerYAnchor).isActive = true
        mapBarTitle.centerXAnchor.constraint(equalTo: mapBarSelectedContaner.centerXAnchor).isActive = true
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mapViewCellId, for: indexPath) as! MapViewCell
        
        if indexPath.item == 0 {
            cell.backgroundColor = .red
        } else {
            cell.backgroundColor = .green
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class MapViewCell: BaseCell {
    
    override func setupViews() {
        super.setupViews()
        
        
    }
}
