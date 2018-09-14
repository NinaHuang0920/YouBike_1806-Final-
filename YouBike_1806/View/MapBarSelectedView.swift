//
//  BikeMapBar.swift
//  YouBike_1806
//
//  Created by 黃玉玲 on 2018/6/20.
//  Copyright © 2018年 CheshireCat. All rights reserved.
//

import UIKit
import MapKit

let mapChangeNotificationName = Notification.Name(rawValue: mapChangeNotificationKey)

class MapBarSelectedView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let cellId = "cellId"
    private let imageNames = ["bicycle", "parking"]
    
    var horizontalLeftAnchorConstraint: NSLayoutConstraint?
    var mapViewController: MapViewController?
    
    lazy var collectionView : UICollectionView = {
        let leyout = UICollectionViewFlowLayout()
        leyout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: leyout)
        cv.backgroundColor = UIColor.clear
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupCollectionView()
        setupHorizontalBar()
        
    }
    
    func setupCollectionView() {
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        collectionView.register(MapBarSelectedViewCell.self, forCellWithReuseIdentifier: cellId)
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
    }

    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = navigationTitleColor
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)

        horizontalLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalLeftAnchorConstraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
     }
    
    // MapBar移動的設定
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        //讓ManuBar 隨著點選ManuBarCollection而移動
//        let x = CGFloat(indexPath.item) * (self.frame.width / 2)
//        horizontalLeftAnchorConstraint?.constant = x
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.layoutIfNeeded()
//        }, completion: nil)
//        // end
        mapViewController?.scrollToMenuIndex(menuIndex: indexPath.item)
//        mapViewBaseCell.mapBarItem = indexPath.item
      
         NotificationCenter.default.post(name: mapChangeNotificationName, object: nil)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let removeAnnotationsName = Notification.Name(rawValue: removeAnnotationsNotificationKey)
        NotificationCenter.default.post(name: removeAnnotationsName, object: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MapBarSelectedViewCell
        cell.backgroundColor = .clear
        cell.selectedBarImage.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width/2, height: self.frame.height)
    }  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MapBarSelectedViewCell: BaseCell {
    
    let selectedBarImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "bicycle").withRenderingMode(.alwaysTemplate)
        image.contentMode = .scaleAspectFit
        image.tintColor = selectedMapBarItemColor
        return image
    }()
    
    override var isSelected: Bool {
        didSet {
            selectedBarImage.tintColor = isSelected ? navigationTitleColor : selectedMapBarItemColor
        }
    }
    
    override func setupViews() {
        super.setupViews()
        addSubview(selectedBarImage)
        selectedBarImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 5, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}


