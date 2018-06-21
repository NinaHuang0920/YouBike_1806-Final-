//
//  BikeCollectionViewController.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/18.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit

class BikeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var bikeDatas: [BikeStationInfo]?
    
   static var bikeControllerInstance = BikeCollectionViewController()
    
    let networkCheckFailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = "NETWORK FAIL \n網路沒開/網址錯誤"
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()

        SetService()
        
        navigationItem.title = "租賃站列表"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 22)]
        navigationController?.navigationBar.barTintColor = stationBarColor
        navigationController?.navigationBar.isTranslucent = false
        
        collectionView?.backgroundColor = mainViewBackgroundColor
        collectionView?.alwaysBounceVertical = true
        self.collectionView!.register(BikeCell.self, forCellWithReuseIdentifier: cellId)
        
        setupNatWorkFailMessage(showMessage: networkCheckFail!)
    }

    func SetService() {
        Service.sharedInstance.fetchJsonData(urlString: webString, completion: { (bikeinfos, err) in
            if let err = err {
                print("ViewController error fetching json:", err)
            }
            if let bikeinfos = bikeinfos {
                self.bikeDatas = bikeinfos
            }
            DispatchQueue.main.async {
                self.setupNatWorkFailMessage(showMessage: networkCheckFail!)
                self.collectionView?.reloadData()
            }
        })
    }
    
    func setupNatWorkFailMessage(showMessage: Bool) {
            networkCheckFailLabel.isHidden = !showMessage
            view.addSubview(networkCheckFailLabel)
            networkCheckFailLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            networkCheckFailLabel.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bikeDatas?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BikeCell
        cell.bikeStationInfo = self.bikeDatas?[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 10, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(5, 0, 0, 0)
    }
    
}



