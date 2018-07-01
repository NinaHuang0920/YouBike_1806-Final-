//
//  BikeCollectionViewController.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/18.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit

class BikeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var bikeDatas: [BikeStationInfo]?
    
    var refreshControl = UIRefreshControl()
    
    let networkCheckFailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = "資料載入失敗\n重新下拉更新"
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let refreshFailLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = "更新失敗\n請確認網路狀態"
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()

        SetService()
        
        navigationItem.title = "租賃站列表"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 22), NSAttributedStringKey.foregroundColor: mapBarColor]
        navigationController?.navigationBar.barTintColor = stationBarColor
        navigationController?.navigationBar.isTranslucent = false
        
        collectionView?.backgroundColor = mainViewBackgroundColor
        collectionView?.alwaysBounceVertical = true
        self.collectionView!.register(BikeCell.self, forCellWithReuseIdentifier: cellId)
        
        setupNatWorkFailMessage(showMessage: networkCheckFail!)
        setupRefreshControl()

    }
    

    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshContents), for: .valueChanged)
        if #available(iOS 10.0, *) {
            collectionView?.refreshControl = refreshControl
        } else {
            collectionView?.addSubview(refreshControl)
        }
    }
    
    @objc func refreshContents() {
        refreshControl.attributedTitle = NSAttributedString(string: "資料更新中")
         self.showRefreshFailMessage(showMessage: false)
        self.bikeDatas?.removeAll()
        self.SetService()
        self.collectionView?.reloadData()
        self.perform(#selector(finishedRefreshing), with: nil, afterDelay: 1.5)
    }
    
    @objc func finishedRefreshing() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.refreshControl.attributedTitle = NSAttributedString(string: "資料更新完畢")
        }, completion: { _ in
            self.refreshControl.endRefreshing()
            if let bikeDataCount = self.bikeDatas?.count {
                if bikeDataCount == 0 {
                    self.showRefreshFailMessage(showMessage: true)
                } else {
                    self.showRefreshFailMessage(showMessage: false)
                }
            } else {
                self.setupNatWorkFailMessage(showMessage: false)
                self.showRefreshFailMessage(showMessage: true)
            }
        })
    }
    
    func showRefreshFailMessage(showMessage: Bool) {
        refreshFailLabel.isHidden = !showMessage
        view.addSubview(refreshFailLabel)
        refreshFailLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        refreshFailLabel.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
    }
    
    func SetService() {
        Service.sharedInstance.fetchJsonData(urlString: webString, completion: { (bikeinfos, err) in
            if let err = err {
                print("BikeViewController error fetching json:", err)
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



