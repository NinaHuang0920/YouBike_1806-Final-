//
//  TabBarController.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/20.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        let bikeCollectionViewController = BikeViewController(collectionViewLayout: layout)
        let navigationController = UINavigationController(rootViewController: bikeCollectionViewController)
        navigationController.title = "站點"
        navigationController.tabBarItem.image = #imageLiteral(resourceName: "note")
        
        let mapLayout = UICollectionViewFlowLayout()
        mapLayout.scrollDirection = .horizontal
        let mapViewController = MapViewController(collectionViewLayout: mapLayout)
        let secondnavigationController = UINavigationController(rootViewController: mapViewController)
        secondnavigationController.title = "地圖"
        secondnavigationController.tabBarItem.image = #imageLiteral(resourceName: "map")
        
        let infoView = InformationView()
        let infoNavgationController = UINavigationController(rootViewController: infoView)
        infoNavgationController.title = "更多"
        infoNavgationController.tabBarItem.image = #imageLiteral(resourceName: "information")
        
        viewControllers = [secondnavigationController, navigationController, infoNavgationController]
        tabBar.isTranslucent = false
        tabBar.tintColor = mapBarColor
        
        
//        let topBorder = CALayer()
//        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
//        topBorder.backgroundColor = mapBarColor.cgColor
//        
//        tabBar.layoutSublayers(of: topBorder)
    }

   

}
