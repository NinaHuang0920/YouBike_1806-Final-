//
//  BikeMapView.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/20.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

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
    
    
    
    
}

