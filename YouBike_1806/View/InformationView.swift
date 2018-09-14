//
//  InformationView.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/20.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit

class InformationView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = mainViewBackgroundColor
        
        navigationItem.title = "More Info"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 22), NSAttributedStringKey.foregroundColor: navigationTitleColor]
        navigationController?.navigationBar.barTintColor = navigationBarColor
        
        navigationController?.navigationBar.isTranslucent = false
    }

    

}
