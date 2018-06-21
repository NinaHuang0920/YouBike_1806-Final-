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
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 22)]
        navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 250, green: 246, blue: 227)
        navigationController?.navigationBar.isTranslucent = false
    }

    

}
