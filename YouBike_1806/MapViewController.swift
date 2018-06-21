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
//    let mapViewLayout = UICollectionViewFlowLayout()
    
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

//    let mapView = MapView()
    
    let mapBarSelectedCollectionView = MapBarSelectedView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupMapBarSelectedView()
//        setupMapView()
        
//        delegate = self
//        dataSource = self
//        setupViews()
        setupMapBarSelectedView()
        
        collectionView?.register(MapViewCell.self, forCellWithReuseIdentifier: mapViewCellId)
        
//        collectionView.scrollDirection = .horizontal
        collectionView?.backgroundColor = mainViewBackgroundColor
        
        
    }

//    func setupMapView() {
//        view.addSubview(mapView)
//        mapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
//    }
    
    func setupNavBar() {
        navigationItem.title = "地圖"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 22)]
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 250, green: 246, blue: 227)
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.titleView = mapBarSelectedContaner
    }

    func setupMapBarSelectedView() {
        mapBarSelectedContaner.addSubview(mapBarSelectedCollectionView)
        mapBarSelectedContaner.addSubview(mapBarTitle)
        
        mapBarSelectedCollectionView.anchor(top: mapBarSelectedContaner.topAnchor, left: mapBarSelectedContaner.leftAnchor, bottom: mapBarSelectedContaner.bottomAnchor, right: mapBarSelectedContaner.rightAnchor, topConstant: 0, leftConstant: mapBarSelectedContaner.frame.width*0.65, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        mapBarTitle.centerYAnchor.constraint(equalTo: mapBarSelectedContaner.centerYAnchor).isActive = true
        mapBarTitle.centerXAnchor.constraint(equalTo: mapBarSelectedContaner.centerXAnchor).isActive = true
        
    }
    
//    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
//        super.init(frame: frame, collectionViewLayout: mapViewLayout)
//        delegate = self
//        dataSource = self
//        setupViews()
//        setupNavBar()
//        setupMapBarSelectedView()
//
//    }
    
//    func setupViews() {
//        register(MapViewCell.self, forCellWithReuseIdentifier: mapViewCellId)
//        mapViewLayout.scrollDirection = .horizontal
//        backgroundColor = mainViewBackgroundColor
//    }
    
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
