//
//  Alert.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/7/24.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit

class Alert {
    
    class func showAlert(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}
