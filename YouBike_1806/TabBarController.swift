//
//  TabBarController.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/20.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit
import MapKit

class TabBarController: UITabBarController {

    let locationService: LocationService
    
    init(locationService: LocationService) {
        self.locationService = locationService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        let bikeCollectionViewController = StationController(collectionViewLayout: layout)
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
        
        viewControllers = [navigationController, secondnavigationController, infoNavgationController]
        tabBar.isTranslucent = false
        tabBar.tintColor = mapBarColorBlue
        
    }

   

}
